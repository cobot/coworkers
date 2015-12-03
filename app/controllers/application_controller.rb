class ApplicationController < ActionController::Base
  include CobotClient::XdmHelper
  protect_from_forgery
  before_filter :match_user_against_cobot_iframe, :require_authentication, :set_embedded,
    :set_variant

  helper_method :current_user

  layout :current_layout

  private

  def set_variant
    if params[:cobot_layout_version] == '2'
      session[:new_variant] = true
    elsif params[:cobot_layout_version] == '1'
      session[:new_variant] = false
    end
    if session[:new_variant] || !@embedded
      new_variant
    end
  end

  def new_variant
    request.variant = :new
  end

  def match_user_against_cobot_iframe
    if current_user && params[:cobot_embed] && params[:cobot_user_id]
      if current_user.cobot_id != params[:cobot_user_id]
        reset_session
      end
    end
  end

  def set_embedded
    if params[:cobot_embed] == 'true'
      session[:embedded] = true
    end
    if session[:embedded]
      @embedded = true
      response.headers.except! 'X-Frame-Options'
    end
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
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def not_allowed
    respond_to do |format|
      format.html do
        if current_user
          render file: Rails.root.join('public', '403.html'), status: 403, layout: false
        else
          redirect_to new_session_path
        end
      end
      format.json do
        head 403
      end
    end
  end

end
