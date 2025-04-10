class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :player

  validates :start_date, :end_date, presence: true

  validate :player_not_in_current_user_club

  def calculate_total_price(price_per_day)
    (end_date - start_date).to_i * price_per_day
  end

  private

  def player_not_in_current_user_club
    if user && player && user.club.id == player.club_id
      errors.add(:player_name, "ne peut pas appartenir à votre club")
    end
  end
end
