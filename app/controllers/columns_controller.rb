class ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [:update, :destroy, :move]

  def create
    @column = @board.columns.build(column_params)

    if @column.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      redirect_to @board, alert: "Could not create column."
    end
  end

  def update
    if @column.update(column_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      redirect_to @board, alert: "Could not update column."
    end
  end

  def destroy
    @column.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @board }
    end
  end

  def move
    @column.move_to(params[:position].to_i)
    head :ok
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def set_column
    @column = @board.columns.find(params[:id])
  end

  def column_params
    params.require(:column).permit(:name)
  rescue ActionController::ParameterMissing
    { name: params[:name] }
  end
end
