module RequireAdmin
  extend ActiveSupport::Concern

  included do
    before_filter :require_admin
  end

  private

  def require_admin
    not_allowed unless current_user.admin_of?(@space)
  end
end
