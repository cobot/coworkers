class User
  include CouchPotato::Persistence

  Admin = Struct.new(:name)

  property :cobot_id
  property :email
  property :admin_of, default: [] # space ids
  property :access_token

  view :by_email, key: :email
  view :by_cobot_id, key: :cobot_id
  view :by_id, key: :_id

  def admin_of?(space)
    admin_of.map{|attributes| attributes['space_id']}.include?(space.id)
  end

  def membership_for(space)
    database.first Membership.by_space_id_and_user_id([space.id, id])
  end
  alias_method :member_of?, :membership_for

  def admin_for(space)
    if attributes = admin_of.find{|attr| attr['space_id'] == space.id}
      Admin.new(attributes['name'])
    end
  end
end
