class User < ActiveRecord::Base
  Admin = Struct.new(:name)
  serialize :admin_of
  has_many :memberships

  def admin_of?(space)
    admin_of.map{|attributes| attributes[:space_id]}.include?(space.cobot_id)
  end

  def membership_for(space)
    Membership.where(space_id: space.id, user_id: id).first
  end
  alias_method :member_of?, :membership_for

  def admin_for(space)
    if attributes = admin_of.find{|attr| attr[:space_id] == space.cobot_id}
      Admin.new(attributes[:name])
    end
  end
end
