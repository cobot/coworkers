class MembershipsController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  
  def show
    @space = db.load params[:space_id]
    @membership = db.load params[:id]
    @user = @membership.user
  end
  
  def destroy
    @space = db.load params[:space_id]
    return not_allowed unless current_user.admin_of?(@space)
    @membership = db.load params[:id]
    db.destroy @membership
    redirect_to @space, notice: 'The member was removed.'
  end
end