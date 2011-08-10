class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  
  def show
    @space = db.load! params[:id]
    not_allowed unless @space.viewable_by?(current_user)
  end

  def update
    space = db.load! params[:id]
    space.members_only = params[:space][:members_only]
    db.save! space if space.updatable_by?(current_user)
    redirect_to space_path(space), notice: 'Settings Saved.'
  end
end