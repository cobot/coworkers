class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show

  def show
    @space = db.load! params[:id]
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

  def update
    space = db.load! params[:id]
    space.members_only = params[:space][:members_only]
    db.save! space if space.updatable_by?(current_user)
    redirect_to space_path(space), notice: 'Settings Saved.'
  end

  private

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
