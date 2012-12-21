class AccountsController < ApplicationController
  param_protected({user: [:email, :admin_of]}, only: :update)

  def show
    memberships = db.view(Membership.by_user_id(current_user.id))
    @spaces = db.view(Space.by_id(keys: memberships.map(&:space_id) | current_user.admin_of.map{|attr| attr['space_id']}))
    @admin_of_any_space = @spaces.any?{|space| current_user.admin_of?(space)}
  end
end
