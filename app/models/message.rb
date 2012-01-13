class Message
  include CouchPotato::Persistence

  property :text
  property :message_board_id
  property :author_id
  property :author_name

  validates_presence_of :text

  view :by_message_board_id_and_created_at, key: [:message_board_id, :created_id]
end
