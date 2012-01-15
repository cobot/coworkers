class MessageBoardsController < ApplicationController
  before_filter :load_space
  before_filter :check_admin, except: [:index, :show]
  before_filter :check_admin_or_member, only: [:index, :show]

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
      km_record 'Created Board'
    else
      render 'new'
    end
  end

  def show
    @message_board = db.first! MessageBoard.by_space_id_and_id([@space.id, params[:id]])
    @message = Message.new
  end

  def destroy
    @message_board = db.first! MessageBoard.by_space_id_and_id([@space.id, params[:id]])
    db.destroy @message_board
    redirect_to [@space, :message_boards]
  end

  private

  def load_space
    @space = db.load! params[:space_id]
  end

  def check_admin_or_member
    unless current_user && current_user.admin_of?(@space) || @space.member?(current_user)
      not_allowed
    end
  end

  def check_admin
    unless current_user && current_user.admin_of?(@space)
      not_allowed
    end
  end
end
