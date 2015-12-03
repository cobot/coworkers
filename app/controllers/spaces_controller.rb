class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  before_filter :load_space
  before_filter :check_access, except: :show
  before_filter :new_variant

  def show
    respond_to do |f|
      f.html do
        if !@space.viewable_by?(current_user)
          not_allowed
        elsif current_user && !current_user.admin_of?(@space) &&
          (membership = current_user.membership_for(@space)) && !membership.profile_completed?
          flash[:notice] = 'Please fill in your profile first.'
          redirect_to edit_space_membership_path(@space, membership)
        else
          @new_memberships = load_new_memberships
        end
      end
      f.css do
        begin
          @customization = CobotClient::ApiClient.new(nil).get(@space.subdomain, '/customization')
        rescue RestClient::ResourceNotFound
          head :not_found
        end
      end
    end
  end

  def install
    space_url = space_memberships_url(@space)
    links = CobotClient::NavigationLinkService.new(cobot_client, @space.subdomain).install_links [
      CobotClient::NavigationLink.new(section: 'admin/manage', label: 'Coworker Profiles', iframe_url: space_url),
      CobotClient::NavigationLink.new(section: 'admin/setup', label: 'Coworker Profiles', iframe_url: space_questions_url(@space)),
      CobotClient::NavigationLink.new(section: 'members', label: 'Coworkers', iframe_url: space_url)
    ]
    redirect_to links.find{|l| l.section == 'admin/manage'}.user_url
  end

  def update
    @space.members_only = params[:space][:members_only]
    @space.save!
    redirect_to space_path(@space), notice: 'Settings Saved.'
  end

  private

  def cobot_client
    CobotClient::ApiClient.new current_user.access_token
  end

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
