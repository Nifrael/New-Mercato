class Booking < ApplicationRecord
  belongs_to :player
  belongs_to :club

  enum :status, { accepted: 0, pending: 1, refused: 2 }, default: :pending

  validates :start_date, :end_date, presence: true

  validate :validate_time

  private

  def validate_time
    errors.add(:end_time, "doit être postérieure à la date de début.") if self.start_date >= self.end_date
  end
end
