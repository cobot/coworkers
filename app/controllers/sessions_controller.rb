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
    user = create_user user_attributes
    create_memberships user, user_attributes["memberships"]
    user
  end
  
  def create_user(user_attributes)
    user = User.new(login: user_attributes["login"])
    db.save user
    user
  end
  
  def create_memberships(user, memberships_attributes)
    memberships_attributes.each do |membership_attributes|
      db.save Membership.new user_id: user.id,
        space_id: find_or_create_space(membership_attributes['space_url']).id,
        name: access_token.get(membership_attributes['url'])['address']['name']
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
      site: 'https://www.cobot.me',
      parse_json: true,
      authorize_path: '/oauth2/authorize',
      access_token_path: '/oauth2/access_token'
    )
  end
  
  def access_token
    @access_token ||= client.web_server.get_access_token(params[:code], :redirect_uri => authentication_callback_url)
  end
  
end