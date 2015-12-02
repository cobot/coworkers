class MessagesController < ApplicationController
  include LoadSpace
  before_filter :load_board
  before_filter :load_message, only: [:edit, :update, :show]
  param_protected({message: [:message_board_id, :author_id, :author_name]}, only: :update)

  def create
    message = Message.new message_params
    message.message_board_id = @message_board.id
    message.space_id = @message_board.space_id
    if membership = @space.membership_for(current_user)
      message.author_name = membership.name
      message.author_id = membership.id
    elsif admin = current_user.admin_for(@space)
      message.author_name = admin.name
    end
    if membership || admin
      if message.save
        flash[:notice] = 'Message added.'
      end
      redirect_to [@space, @message_board]
    else
      not_allowed
    end
  end

  def edit
  end

  def update
    @message.attributes = message_params
    @message.save
    redirect_to [@space, @message_board, @message]
  end

  def show
  end

  private

  def message_params
    params[:message].permit(:text)
  end

  def load_message
    @message = @message_board.messages.find params[:id]
    not_allowed unless @message.editable_by?(current_user, @space)
  end

  def load_board
    @message_board = @space.message_boards.find params[:message_board_id]
  end
end
