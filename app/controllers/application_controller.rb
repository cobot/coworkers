class ApplicationController < ActionController::Base
  include KissmetricsHelper
  protect_from_forgery
  before_filter :require_authentication
  before_filter :set_embedded

  helper_method :current_user

  rescue_from CouchPotato::NotFound do
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
  end

  layout :current_layout

  private

  def set_embedded
    @embedded = true if params[:cobot_embed] == 'true'
  end

  def current_layout
    if params[:cobot_embed] == 'true'
      'embed'
    else
      'application'
    end
  end

  def default_url_options
    if params[:cobot_embed]
      {cobot_embed: params[:cobot_embed]}
    else
      {}
    end
  end

  def oauth_client
    @oath_client ||= OAuth2::Client.new(Coworkers::Conf.app_id,
      Coworkers::Conf.app_secret,
      site: {
         url: Coworkers::Conf.app_site
      },
      authorize_url: '/oauth2/authorize',
      token_url: '/oauth2/access_token'
    )
  end

  def require_authentication
    unless current_user
      session[:return_to] = request.url
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= db.load!(session[:user_id]) if session[:user_id]
  end

  def db
    @db ||= CouchPotato.database
  end

  def not_allowed
    respond_to do |format|
      format.html do
        if current_user
          render file: Rails.root.join('public', '403.html'), status: 403, layout: false
        else
          redirect_to authenticate_path
        end
      end
      format.json do
        head 403
      end
    end
  end

end
