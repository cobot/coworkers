class MessagesController < ApplicationController
  before_filter :load_space_and_board
  before_filter :load_message, only: [:edit, :update, :show]
  param_protected({message: [:message_board_id, :author_id, :author_name]}, only: :update)

  def create
    message = Message.new params[:message]
    message.message_board_id = @message_board.id
    message.space_id = @message_board.space_id
    if membership = @space.membership_for(current_user)
      message.author_name = membership.name
      message.author_id = membership.id
    elsif admin = current_user.admin_for(@space)
      message.author_name = admin.name
    end
    if membership || admin
      if db.save message
        flash[:notice] = 'Message added.'
        km_record 'Posted Message'
      end
      redirect_to [@space, @message_board]
    else
      not_allowed
    end
  end

  def edit
  end

  def update
    @message.attributes = params[:message]
    db.save @message
    redirect_to [@space, @message_board, @message]
  end

  def show
  end

  private

  def load_message
    @message = db.first! Message.by_message_board_id_and_id([@message_board.id, params[:id]])
    not_allowed unless @message.editable_by?(current_user, @space)
  end

  def load_space_and_board
    @space = db.load! params[:space_id]
    @message_board = db.first! MessageBoard.by_space_id_and_id([@space.id, params[:message_board_id]])
  end
end
