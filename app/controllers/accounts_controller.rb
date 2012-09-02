class AccountsController < ApplicationController
  param_protected({user: [:email, :admin_of]}, only: :update)

  def show
    memberships = db.view(Membership.by_user_id(current_user.id))
    @spaces = db.view(Space.by_id(keys: memberships.map(&:space_id) | current_user.admin_of.map{|attr| attr['space_id']}))
    redirect_to space_path(@spaces.first) if @spaces.size == 1
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
