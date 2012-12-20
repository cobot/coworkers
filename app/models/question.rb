class Question
  include CouchPotato::Persistence

  property :text
  property :type # :short_text|:long_text
  property :space_id

  view :by_space_id_and_created_at, key: [:space_id, :created_at]
  view :by_space_id, key: :space_id

  validates_presence_of :text, :type
end
