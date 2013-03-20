class MessageBoard < ActiveRecord::Base

  validates_presence_of :name

  def messages(limit = 100)
    messages = Message.where(message_board_id: id).order('created_at DESC').limit(limit)
    messages.each {|m| m.message_board = self}
    messages
  end
end
