class Question
  include CouchPotato::Persistence
  
  property :text
  property :type
  property :space_id
  
  view :by_space_id_and_created_at, key: [:space_id, :created_at]
  
  validates_presence_of :text, :type
end