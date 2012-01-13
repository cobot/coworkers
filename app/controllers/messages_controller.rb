class MessagesController < ApplicationController

  def create
    space = db.load! params[:space_id]
    message_board = db.first! MessageBoard.by_space_id_and_id([space.id, params[:message_board_id]])
    message = Message.new params[:message]
    message.message_board_id = message_board.id
    if membership = space.membership_for(current_user)
      message.author_name = membership.name
      message.author_id = membership.id
    elsif admin = current_user.admin_for(space)
      message.author_name = admin.name
    end
    if membership || admin
      db.save message
      redirect_to [space, message_board]
    else
      not_allowed
    end
  end
end
