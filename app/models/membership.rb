class Membership
  include CouchPotato::Persistence

  property :space_id
  property :user_id
  property :name

  # profile information
  property :website
  property :bio
  property :profession
  property :industry
  property :skills
  property :messenger_type
  property :messenger_account
  property :picture, default: 'http://coworkers.apps.cobot.me/assets/default.jpg'

  view :by_user_id, key: :user_id
  view :by_space_id, key: :space_id
  view :by_space_id_and_user_id, key: [:space_id, :user_id]
  view :by_space_id_and_created_at, key: [:space_id, :created_at]

  alias_method :profile_completed?, :bio?

  def user=(user)
    @user = user
  end

  def can_update_picture?
    user.access_token?
  end

  def user
    if user_id
      @user ||= database.load user_id
    else
      User.new
    end
  end

  def last_name
    name.to_s.split(' ').last
  end

  def answers
    database.view Answer.by_membership_id_and_created_at(startkey: [id], endkey: [id, {}])
  end
end
