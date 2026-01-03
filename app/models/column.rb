class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_position, on: :create

  def move_to(new_position)
    return if new_position == position

    if new_position > position
      board.columns.where("position > ? AND position <= ?", position, new_position)
                   .update_all("position = position - 1")
    else
      board.columns.where("position >= ? AND position < ?", new_position, position)
                   .update_all("position = position + 1")
    end
    update!(position: new_position)
  end

  private

  def set_position
    self.position ||= board.columns.maximum(:position).to_i + 1
  end
end
