class CardsController < ApplicationController
  before_action :set_board
  before_action :set_column
  before_action :set_card, only: [:update, :destroy, :move]

  def create
    @card = @column.cards.build(card_params)

    if @card.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      redirect_to @board, alert: "Could not create card."
    end
  end

  def update
    if @card.update(card_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      redirect_to @board, alert: "Could not update card."
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @board }
    end
  end

  def move
    # Use target_column_id from body to avoid conflict with column_id URL param
    target_column_id = params[:target_column_id].presence || @column.id
    target_column = @board.columns.find(target_column_id)
    target_position = params[:position].to_i

    @card.move_to(target_column, target_position)
    head :ok
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def set_column
    @column = @board.columns.find(params[:column_id])
  end

  def set_card
    @card = @column.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :due_date, :priority)
  rescue ActionController::ParameterMissing
    { title: params[:title] }
  end
end
