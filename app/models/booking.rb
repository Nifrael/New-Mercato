class Booking < ApplicationRecord
  include AASM

  belongs_to :player
  belongs_to :club

  enum :status, { accepted: 0, pending: 1, refused: 2 }, default: :pending

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :accepted
    state :refused

    event :accept do
      transitions from: :pending, to: :accepted, after: :update_player_booked
    end

    event :refuse do
      transitions from: :pending, to: :refused
    end
  end

  validates :start_date, :end_date, presence: true

  validate :validate_time
  validate :player_already_in_club, on: :create

  scope :active, -> { where(status: :accepted).where("start_date <= :today AND end_date >= :today", today: Date.today) }

  def calculate_total_price(price_per_day)
    (end_date - start_date).to_i * price_per_day
  end

  private

  def validate_time
    errors.add(:end_time, "doit être postérieure à la date de début.") if self.start_date >= self.end_date
  end

  def player_already_in_club
    if player.club_id == club_id
      errors.add(:base, "Ce joueur appartient déjà à votre club, vous ne pouvez pas le réserver.")
    end
  end

  def update_player_booked
    if player.present?
      player.rented!
    else
      raise ActiveRecord::RecordNotFound, "Erreur lors de la mise à jour du statut du joueur."
    end
  end
end
