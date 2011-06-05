class AccountsController < ApplicationController
  def show
    memberships = db.view(Membership.by_user_id(current_user.id))
    @spaces = db.view(Space.by_id(keys: memberships.map(&:space_id)))
  end
  
  def edit
    @user = current_user
  end
  
  def update
    user = current_user
    user.attributes = params[:user]
    db.save user
    redirect_to account_path, notice: 'Profile information was updated.'
  end
end