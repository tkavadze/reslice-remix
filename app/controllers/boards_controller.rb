class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]

  def index
    @boards = current_user.boards.order(updated_at: :desc)
  end

  def show
    @columns = @board.columns.includes(:cards)
  end

  def new
    @board = current_user.boards.build
  end

  def create
    @board = current_user.boards.build(board_params)

    if @board.save
      redirect_to @board, notice: "Board was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      respond_to do |format|
        format.html { redirect_to @board, notice: "Board was successfully updated." }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path, notice: "Board was successfully deleted."
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :description)
  end
end
