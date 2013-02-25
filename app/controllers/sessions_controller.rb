class SessionsController < ApplicationController
  skip_before_filter :require_authentication

  def new
    redirect_to account_path if current_user
  end

  def create
    user_attributes = request.env['omniauth.auth']['extra']['raw_info']
    user = sign_up user_attributes
    session[:user_id] = user.id
    redirect_to session.delete(:return_to) || account_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    flash[:failure] = "There was a problem: #{params[:message]}"
    redirect_to root_path
  end


  private
  def sign_up(user_attributes)
    user = find_and_update_or_create_user user_attributes
    create_memberships user, user_attributes["memberships"]
    create_spaces user_attributes['admin_of'].map{|admin_of| admin_of['space_link']}
    user
  end

  def create_spaces(links)
    links.each do |link|
      find_or_create_space link
    end
  end

  def find_and_update_or_create_user(user_attributes)
    user = db.first(User.by_cobot_id(user_attributes['id']))
    if user
      user.email = user_attributes["email"]
      user.admin_of = admin_spaces(user_attributes)
      user.access_token = access_token.token
    else
      user = User.new(
        cobot_id: user_attributes['id'],
        email: user_attributes['email'],
        admin_of: admin_spaces(user_attributes),
        access_token: access_token.token
      )
    end
    db.save user if user.changed?
    user
  end
  def create_memberships(user, memberships_attributes)
    memberships_attributes.each do |membership_attributes|
      membership_details = outh_get(membership_attributes['link'])
      membership = db.load(membership_details['id'])
      if !membership_details['confirmed_at'].nil? && !membership_details['canceled_to'] && !membership
        db.save(Membership.new user_id: user.id, id: membership_details['id'],
          space_id: find_or_create_space(membership_attributes['space_link']).id,
          picture: user_attributes["picture"],
          name: membership_details['address']['name'])
      elsif membership
        membership.name = membership_details['address']['name']
        membership.picture = user_attributes["picture"]

        db.save! membership
      end
    end
  end

  def find_or_create_space(space_url)
    space_attributes = outh_get(space_url)
    unless space = db.load(space_attributes['id'])
      space = Space.new name: space_attributes['name'], id: space_attributes['id'],
        cobot_url: space_attributes['url']
      db.save space
      km_record 'Added Space'
    else
      space.cobot_url = space_attributes['url']
      db.save space, false
    end
    space
  end

  def oauth_client
    OAuth2::Client.new(Coworkers::Conf.app_id,
      Coworkers::Conf.app_secret,
      site: {
        url: Coworkers::Conf.site
      },
      raise_errors: false
    )
  end

  def admin_spaces(user_attributes)
    user_attributes['admin_of'].map{|space_attributes|
      {
        space_id: outh_get(space_attributes['space_link'])['id'],
        name: space_attributes['name']
      }
    }
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new(oauth_client, request.env['omniauth.auth']['credentials']['token'])
  end

  def outh_get(url)
    access_token.get(url).parsed
  end
end
