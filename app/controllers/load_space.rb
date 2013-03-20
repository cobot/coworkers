module LoadSpace
  extend ActiveSupport::Concern

  included do
    before_filter :load_space
  end

  private

  def load_space
    @space = Space.by_cobot_id(params[:space_id]).first!
  end
end
