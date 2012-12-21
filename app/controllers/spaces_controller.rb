class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  before_filter :load_space
  before_filter :check_access, except: :show

  def show
    if !@space.viewable_by?(current_user)
      not_allowed
    elsif current_user && !current_user.admin_of?(@space) &&
      (membership = current_user.membership_for(@space)) && !membership.profile_completed?
      flash[:notice] = 'Please fill in your profile first.'
      redirect_to edit_space_membership_path(@space, membership)
    else
      @new_memberships = load_new_memberships
      @new_messages = load_new_messages
    end
  end

  def install
    space_url = space_memberships_url(@space)
    links = CobotClient::NavigationLinkService.new(oauth_client, current_user.access_token, @space.subdomain).install_links [
      CobotClient::NavigationLink.new(section: 'admin/manage', label: 'Coworker Profiles', iframe_url: space_url),
      CobotClient::NavigationLink.new(section: 'admin/setup', label: 'Coworker Profiles', iframe_url: space_questions_url(@space)),
      CobotClient::NavigationLink.new(section: 'members', label: 'Coworkers', iframe_url: space_url)
    ]
    redirect_to links.find{|l| l.section == 'admin/manage'}.user_url
  end

  def update
    @space.members_only = params[:space][:members_only]
    db.save! @space
    redirect_to space_path(@space), notice: 'Settings Saved.'
  end

  private

  def load_space
    @space = db.load! params[:id]
  end

  def check_access
    not_allowed unless @space.updatable_by?(current_user)
  end

  def load_new_memberships
    new_memberships = @space.new_memberships
    users = db.view(User.by_id(keys: new_memberships.map(&:user_id)))
    new_memberships.each {|m| m.user = users.find{|u| u.id == m.user_id}}
    new_memberships
  end

  def load_new_messages
    new_messages = db.view(Message.by_space_id_and_created_at(
        startkey: [@space.id, {}], endkey: [@space.id], descending: true, limit: 3))
    message_boards = db.view(MessageBoard.by_id(keys: new_messages.map(&:message_board_id).uniq))
    new_messages.each do |m|
      m.message_board = message_boards.find{|b| b.id == m.message_board_id}
    end
    new_messages
  end
end
