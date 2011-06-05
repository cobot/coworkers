class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_authentication
  
  helper_method :current_user
  
  rescue_from CouchPotato::NotFound do
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
  end
  
  private
  
  def require_authentication
    unless current_user
      redirect_to root_path
      false
    end
  end
  
  def current_user
    @current_user ||= db.load!(session[:user_id]) if session[:user_id]
  end
  
  def db
    @db ||= CouchPotato.database
  end
end
