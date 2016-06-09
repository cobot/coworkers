class User < ActiveRecord::Base
  Admin = Struct.new(:name)
  has_many :memberships

  def admin_of?(space)
    admin_of.key? space.cobot_id
  end

  def membership_for(space)
    Membership.where(space_id: space.id, user_id: id).first
  end
  alias_method :member_of?, :membership_for

  def admin_for(space)
    if (name = admin_of[space.cobot_id])
      Admin.new(name)
    end
  end
end
