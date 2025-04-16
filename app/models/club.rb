class Club < ApplicationRecord
  has_many :users
  has_many :players
  has_many :bookings
  has_many :players, through: :bookings

  validates :name, presence: true, uniqueness: true
  validates :stadium, :logo, presence: true
end
