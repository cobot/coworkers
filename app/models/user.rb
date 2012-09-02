class User
  include CouchPotato::Persistence

  Admin = Struct.new(:name)

  property :cobot_id
  property :email
  property :admin_of, default: [] # space ids
  property :picture, default: 'http://coworkers.apps.cobot.me/images/default.jpg'
  property :access_token

  # profile information
  property :website
  property :bio
  property :profession
  property :industry
  property :skills
  property :messenger_type
  property :messenger_account

  view :by_email, key: :email
  view :by_cobot_id, key: :cobot_id
  view :by_id, key: :_id

  def admin_of?(space)
    admin_of.map{|attributes| attributes['space_id']}.include?(space.id)
  end

  def admin_for(space)
    if attributes = admin_of.find{|attr| attr['space_id'] == space.id}
      Admin.new(attributes['name'])
    end
  end

  alias_method :profile_completed?, :bio?

end
