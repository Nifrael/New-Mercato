class Player < ApplicationRecord
  belongs_to :club
  has_many :bookings

  enum :position, { gardien: 0, defenseur: 1, milieu: 2, attaquant: 3, polyvalent: 4 }, default: :polyvalent
  enum :status, { unavailable: 0, rented: 1, available: 2 }, default: :available
end
