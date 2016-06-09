class AccountsController < ApplicationController
  param_protected({user: [:email, :admin_of]}, only: :update)
  before_filter :new_variant

  def show
    memberships = Membership.where(user_id: current_user.id)
    @spaces = Space.where(id: memberships.map(&:space_id)) | Space.where(cobot_id: current_user.admin_of.keys)
    @admin_of_any_space = @spaces.any? {|space| current_user.admin_of?(space) }
  end
end
