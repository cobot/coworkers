class MessagesController < ApplicationController

  def create
    space = db.load! params[:space_id]
    if membership = space.membership_for(current_user)
      message_board = db.first! MessageBoard.by_space_id_and_id([space.id, params[:message_board_id]])
      message = Message.new params[:message]
      message.author_name = membership.name
      message.author_id = membership.id
      message.message_board_id = message_board.id
      db.save message
      redirect_to [space, message_board]
    else
      not_allowed
    end
  end
end
