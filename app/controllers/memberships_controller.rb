class MembershipsController < ApplicationController
  include LoadSpace

  layout 'embed'
  
  skip_before_filter :require_authentication, only: :show
  param_protected({membership: [:space_id, :user_id]}, only: :update)
  param_protected({user: [:cobot_id, :admin_of, :email, :access_token]}, only: :update)

  def index
    if !@space.viewable_by?(current_user)
      not_allowed
    else
      scope = @space.memberships.active.includes(:user)
      scope  = scope.published unless current_user.admin_of?(@space)
      @memberships = scope.sort_by {|m| m.name.to_s.downcase }
    end
  end

  def update
    @membership = @space.memberships.find params[:id]
    return not_allowed unless check_access @membership
    @membership.attributes = membership_params
    @membership.save
    redirect_to [@space, @membership]
  end

  def show
    @membership = @space.memberships.find params[:id]
    @user = @membership.user
  end

  def destroy
    @membership = @space.memberships.find params[:id]
    return not_allowed unless check_access @membership
    @membership.destroy
    redirect_to [@space, :memberships], notice: 'The profile was removed.'
  end

  private

  def check_access(membership)
    current_user&.admin_of?(@space) ||
      (current_user&.member_of?(@space) && current_user&.membership_for(@space)&.id == membership.id)
  end

  def cobot_client(access_token)
    @cobot_client ||= CobotClient::ApiClient.new access_token
  end

  def membership_params
    params[:membership].permit(:public)
  end
end
