module LoadSpace
  extend ActiveSupport::Concern

  included do
    before_filter :load_space
  end

  private

  def load_space
    @space = db.load! params[:space_id]
  end
end
