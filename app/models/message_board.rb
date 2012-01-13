class MessageBoard
  include CouchPotato::Persistence

  property :name
  property :space_id

  validates_presence_of :name

  view :by_space_id_and_name, key: [:space_id, :name]
  view :by_space_id_and_id, key: [:space_id, :_id]

  def messages(limit = 999)
    database.view(Message.by_message_board_id_and_created_at(startkey: [id, {}], endkey: [id], limit: limit, descending: true))
  end
end
