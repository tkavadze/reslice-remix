class Board < ApplicationRecord
  belongs_to :user
  has_many :columns, -> { order(position: :asc) }, dependent: :destroy
  has_many :cards, through: :columns

  validates :title, presence: true

  after_create :create_default_columns

  private

  def create_default_columns
    columns.create([
      { name: "To Do", position: 0 },
      { name: "In Progress", position: 1 },
      { name: "Done", position: 2 }
    ])
  end
end
