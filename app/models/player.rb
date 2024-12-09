class Player < ApplicationRecord
  has_many :bookings
  belongs_to :club

  alias_attribute :photo, :img
  has_one_attached :photo

  enum position: { Gardien: 1, Défenseur: 2, Milieu: 3, Attaquant: 4 }

  validates :name, :age, :position, :nationality, :foot, :club, :market_value, presence: true

  def self.sorted_by_position
    all.sort_by do |player|
      case player.position
      when 'Gardien'
        1
      when 'Défenseur'
        2
      when 'Milieu'
        3
      when 'Attaquant'
        4
      end
    end
  end

  def self.sorted_by_price
    all.order(price_per_day: :asc)
  end
end
