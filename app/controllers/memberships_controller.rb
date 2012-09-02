class MembershipsController < ApplicationController
  include LoadSpace
  skip_before_filter :require_authentication, only: :show

  def index
    if !@space.viewable_by?(current_user)
      not_allowed
    else
      @memberships = @space.memberships
      users = db.view(User.by_id(keys: @memberships.map(&:user_id)))
      @memberships.each {|m| m.user = users.find{|u| u.id == m.user_id}}
    end
  end

  def show
    @membership = db.load! params[:id]
    @user = @membership.user
  end

  def destroy
    return not_allowed unless current_user.admin_of?(@space)
    @membership = db.load! params[:id]
    db.destroy @membership
    redirect_to [@space, :memberships], notice: 'The member was removed.'
  end
end
