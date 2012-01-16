class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show

  def show
    @space = db.load! params[:id]
    if !@space.viewable_by?(current_user)
      not_allowed
    elsif current_user && !current_user.admin_of?(@space) && !current_user.profile_completed?
      flash[:notice] = 'Please fill in your profile first.'
      redirect_to edit_account_path
    else
      @memberships = @space.memberships
      users = db.view(User.by_id(keys: @memberships.map(&:user_id)))
      @memberships.each {|m| m.user = users.find{|u| u.id == m.user_id}}
    end
  end

  def update
    space = db.load! params[:id]
    space.members_only = params[:space][:members_only]
    db.save! space if space.updatable_by?(current_user)
    redirect_to space_path(space), notice: 'Settings Saved.'
  end
end
