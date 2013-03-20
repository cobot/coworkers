class MessageBoardsController < ApplicationController
  include LoadSpace

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
    if @message_board.save
      redirect_to space_message_boards_path(@space)
    else
      render 'new'
    end
  end

  def show
    @message_board = @space.message_boards.find params[:id]
    @message = Message.new
  end

  def destroy
    @message_board = @space.message_boards.find params[:id]
    @message_board.destroy
    redirect_to [@space, :message_boards]
  end

  private

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
