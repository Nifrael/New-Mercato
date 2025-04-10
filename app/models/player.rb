class Player < ApplicationRecord
  has_many :bookings
  belongs_to :club

  alias_attribute :photo, :img
  has_one_attached :photo

  enum :status, { available: 0, rented: 1, unavailable: 2 }
  enum :position, { gardien: 0, defenseur: 1, milieu: 2, attaquant: 3, polyvalent: 4 }

  validates :name, :age, :position, :nationality, :foot, :club, :market_value, presence: true

  def self.sorted_by_price
    all.order(price_per_day: :asc)
  end
end
