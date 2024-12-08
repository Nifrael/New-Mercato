class Club < ApplicationRecord
  belongs_to :user, optional: true
  validates :user, uniqueness: true, allow_nil: true
  has_many :players

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true

  def players_grouped_by_position
    players.group_by(&:position)
  end
end
