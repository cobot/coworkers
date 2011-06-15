class SpacesController < ApplicationController
  skip_before_filter :require_authentication, only: :show
  
  def show
    @space = db.load! params[:id]
  end
end