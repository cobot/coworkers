class SessionsController < ApplicationController
  skip_before_filter :require_authentication
  
  def authenticate
    redirect_to client.web_server.authorize_url(
      redirect_uri: authentication_callback_url,
      scope: 'read'
    )
  end
  
  def create
    user_attributes = access_token.get('/api/user')
    user = sign_up user_attributes
    session[:user_id] = user.id
    redirect_to account_path
  end
  
  private
  
  def sign_up(user_attributes)
    user = find_or_create_user user_attributes
    create_memberships user, user_attributes["memberships"]
    user
  end
  
  def find_or_create_user(user_attributes)
    unless user = db.first(User.by_login(user_attributes["login"]))
      user = User.new(login: user_attributes["login"])
      db.save user
    end
    user
  end
  
  def create_memberships(user, memberships_attributes)
    memberships_attributes.each do |membership_attributes|
      membership_details = access_token.get(membership_attributes['link'])
      unless db.load membership_details['id']
        db.save Membership.new user_id: user.id, id: membership_details['id'],
          space_id: find_or_create_space(membership_attributes['space_link']).id,
          name: membership_details['address']['name']
      end
    end
  end
  
  def find_or_create_space(space_url)
    space_attributes = access_token.get(space_url)
    unless space = db.load(space_attributes['id'])
      space = Space.new name: space_attributes['name'], id: space_attributes['id']
      db.save space
    end
    space
  end
  
  def client
    OAuth2::Client.new(Coworkers::Conf.app_id,
      Coworkers::Conf.app_secret,
      site: Coworkers::Conf.app_site,
      parse_json: true,
      authorize_path: '/oauth2/authorize',
      access_token_path: '/oauth2/access_token'
    )
  end
  
  def access_token
    @access_token ||= client.web_server.get_access_token(params[:code], :redirect_uri => authentication_callback_url)
  end
  
end