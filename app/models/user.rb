class User
  include CouchPotato::Persistence

  property :email
  property :admin_of, default: [] # space ids
  property :picture, default: 'http://coworkers.apps.cobot.me/images/default.jpg'

  # profile information
  property :website
  property :bio
  property :profession
  property :industry
  property :skills
  property :messenger_type
  property :messenger_account

  view :by_email, key: :email
  view :by_id, key: :_id

  def admin_of?(space)
    admin_of.include?(space.id)
  end

end
