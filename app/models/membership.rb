class Membership
  include CouchPotato::Persistence
  
  property :space_id
  property :user_id
  property :name
  
  view :by_user_id, key: :user_id
  view :by_space_id, key: :space_id
  view :by_space_id_and_user_id, key: [:space_id, :user_id]
  
  def user
    database.load user_id
  end
  
  def answers
    database.view Answer.by_membership_id_and_created_at(startkey: [id], endkey: [id, {}])
  end
end