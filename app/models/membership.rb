class Membership
  include CouchPotato::Persistence

  property :space_id
  property :user_id
  property :name

  view :by_user_id, key: :user_id
  view :by_space_id, key: :space_id
  view :by_space_id_and_user_id, key: [:space_id, :user_id]
  view :by_space_id_and_created_at, key: [:space_id, :created_at]

  def user=(user)
    @user = user
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
