class Message
  include CouchPotato::Persistence

  property :text
  property :message_board_id
  property :author_id
  property :author_name
  property :space_id

  attr_writer :message_board

  validates_presence_of :text

  view :by_message_board_id_and_created_at, key: [:message_board_id, :created_at]
  view :by_space_id_and_created_at, key: [:space_id, :created_at]
  view :by_message_board_id_and_id, key: [:message_board_id, :_id]

  def message_board
    @message_board ||= database.load message_board_id
  end

  def editable_by?(user, space)
    user && author_id = user.id || user.admin_of?(space)
  end
end
