class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  before_filter :load_space
  before_filter :check_access, except: :show

  def cobot_client
    CobotClient::ApiClient.new @space.access_token
  end

  def install
    space_url = space_memberships_url(@space)
    links = CobotClient::NavigationLinkService.new(cobot_client, @space.subdomain).install_links [
      CobotClient::NavigationLink.new(section: 'admin/manage', label: 'Member Directory', iframe_url: space_url),
      CobotClient::NavigationLink.new(section: 'admin/setup', label: 'Member Directory', iframe_url: space_questions_url(@space)),
      CobotClient::NavigationLink.new(section: 'members', label: 'Member Directory', iframe_url: space_url)
    ]
    redirect_to links.find {|l| l.section == 'admin/manage' }.user_url
  end

  private

  def load_space
    @space = Space.by_cobot_id(params[:id]).first!
  end

  def check_access
    not_allowed unless @space.updatable_by?(current_user)
  end

  def load_new_memberships
    @space.new_memberships.includes(:user)
  end
end
