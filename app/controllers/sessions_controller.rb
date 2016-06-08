class SessionsController < ApplicationController
  skip_before_filter :require_authentication
  before_filter :new_variant

  def new
    session[:embedded] = nil
    session[:new_variant] = nil
    redirect_to '/auth/cobot'
  end

  def show

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
    flash[:notice] = "There was a problem: #{params[:message]}"
    redirect_to root_path
  end

  private

  def access_token
    @access_token ||= OAuth2::AccessToken.new(oauth_client, request.env['omniauth.auth']['credentials']['token'])
  end

  def sign_up(user_attributes)
    SignupService.new(user_attributes, access_token, self).run
  end
end
