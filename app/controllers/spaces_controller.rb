class SpacesController < ApplicationController
  def show
    @space = db.load! params[:id]
  end
end