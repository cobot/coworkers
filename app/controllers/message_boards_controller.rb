class MessageBoardsController < ApplicationController
  before_filter :load_space
  before_filter :check_permissions, except: :index

  def index
    @message_boards = @space.message_boards
  end

  def new
    @message_board = MessageBoard.new
  end

  def create
    @message_board = MessageBoard.new params[:message_board]
    @message_board.space_id = @space.id
    if db.save @message_board
      redirect_to space_message_boards_path(@space)
    else
      render 'new'
    end
  end

  private

  def load_space
    @space = db.load! params[:space_id]
  end

  def check_permissions
    unless current_user && current_user.admin_of?(@space)
      not_allowed
    end
  end
end
