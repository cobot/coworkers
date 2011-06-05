class MembershipsController < ApplicationController
  def show
    @space = db.load params[:space_id]
    @membership = db.load params[:id]
    @user = @membership.user
  end
end