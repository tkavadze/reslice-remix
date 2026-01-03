class Card < ApplicationRecord
  belongs_to :column

  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  before_validation :set_position, on: :create

  enum :priority, { no_priority: 0, low: 1, medium: 2, high: 3 }

  scope :overdue, -> { where("due_date < ?", Date.current) }
  scope :due_soon, -> { where(due_date: Date.current..3.days.from_now) }

  delegate :board, to: :column

  def move_to(target_column, target_position)
    transaction do
      if column_id == target_column.id
        move_within_column(target_position)
      else
        move_to_column(target_column, target_position)
      end
    end
  end

  def overdue?
    due_date.present? && due_date < Date.current
  end

  def due_soon?
    due_date.present? && due_date >= Date.current && due_date <= 3.days.from_now
  end

  private

  def set_position
    self.position ||= column.cards.maximum(:position).to_i + 1
  end

  def move_within_column(target_position)
    return if target_position == position

    if target_position > position
      column.cards.where("position > ? AND position <= ?", position, target_position)
                  .update_all("position = position - 1")
    else
      column.cards.where("position >= ? AND position < ?", target_position, position)
                  .update_all("position = position + 1")
    end
    update!(position: target_position)
  end

  def move_to_column(target_column, target_position)
    column.cards.where("position > ?", position).update_all("position = position - 1")
    target_column.cards.where("position >= ?", target_position).update_all("position = position + 1")
    update!(column: target_column, position: target_position)
  end
end
