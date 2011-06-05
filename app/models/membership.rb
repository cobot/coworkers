class Membership
  include CouchPotato::Persistence
  
  property :space_id
  property :user_id
  property :name
  
  view :by_user_id, key: :user_id
  view :by_space_id, key: :space_id
  
  def user
    database.load user_id
  end
end