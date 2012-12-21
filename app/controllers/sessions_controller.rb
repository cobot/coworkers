class SessionsController < ApplicationController
  skip_before_filter :require_authentication

  def new
    redirect_to account_path if current_user
  end

  def authenticate
    redirect_to oauth_client.auth_code.authorize_url(
      redirect_uri: authentication_callback_url,
      scope: 'read navigation'
    )
  end

  def create
    if params[:error]
      render text: params[:error_description]
    else
      user = sign_up
      session[:user_id] = user.id
      redirect_to account_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def sign_up
    user = find_and_update_or_create_user
    create_memberships user, user_attributes["memberships"]
    create_spaces user_attributes['admin_of'].map{|admin_of| admin_of['space_link']}
    user
  end

  def user_attributes
    @user_attributes ||= access_token.get('/api/user').parsed
  end

  def create_spaces(links)
    links.each do |link|
      find_or_create_space link
    end
  end

  def find_and_update_or_create_user
    unless user = db.first(User.by_cobot_id(user_attributes["id"])) || db.first(User.by_email(user_attributes["email"]))
      user = User.new(email: user_attributes["email"],
        access_token: access_token.token,
        cobot_id: user_attributes['id'],
        admin_of: admin_of)
      db.save(user) && km_record('signed up')
    else
      user.cobot_id ||= user_attributes['id']
      user.access_token = access_token.token
      user.email = user_attributes["email"]
      user.admin_of = admin_of
      db.save user if user.changed?
    end
    user
  end

  def admin_of
    user_attributes['admin_of'].map{|space_attributes|
      {
        space_id: access_token.get(space_attributes['space_link']).parsed['id'],
        name: space_attributes['name']
      }
    }
  end

  def create_memberships(user, memberships_attributes)
    memberships_attributes.each do |membership_attributes|
      membership_details = access_token.get(membership_attributes['link']).parsed
      membership = db.load(membership_details['id'])
      if !membership_details['confirmed_at'].nil? && !membership_details['canceled_to'] && !membership
        db.save(Membership.new user_id: user.id, id: membership_details['id'],
          space_id: find_or_create_space(membership_attributes['space_link']).id,
          picture: user_attributes["picture"],
          name: membership_details['address']['name']) && km_record('Signed up as member')
      elsif membership
        membership.name = membership_details['address']['name']
        membership.picture = user_attributes["picture"]

        db.save! membership
      end
    end
  end

  def find_or_create_space(space_url)
    space_attributes = access_token.get(space_url).parsed
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

  def access_token
    @access_token ||= oauth_client.auth_code.get_token(params[:code], redirect_uri: authentication_callback_url)
  end

end
