class Player < ApplicationRecord
  belongs_to :club
  has_many :bookings

  enum :position, { gardien: 0, defenseur: 1, milieu: 2, attaquant: 3, polyvalent: 4 }, _default: :polyvalent

  before_validation :set_position

  private

  def set_position
    case self.position
    when "Gardien"
      self.position = :gardien
    when "Défenseur"
      self.position = :defenseur
    when "Milieu"
      self.position = :milieu
    when "Attaquant"
      self.position = :attaquant
    else
      self.position = :polyvalent
    end
  end
end
