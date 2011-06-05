class AccountsController < ApplicationController
  def show
    memberships = db.view(Membership.by_user_id(current_user.id))
    @spaces = db.view(Space.by_id(keys: memberships.map(&:space_id)))
  end
end