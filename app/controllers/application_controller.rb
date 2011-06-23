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
  
  def must_be_admin_for_space
    @space = db.load params[:space_id]
    return not_allowed unless current_user.admin_of?(@space)
  end
  
  def db
    @db ||= CouchPotato.database
  end
  
  def not_allowed
    render file: Rails.root.join('public', '403.html'), layout: false, status: 403
  end
end
