class Player < ApplicationRecord
  belongs_to :club
  has_many :bookings

  enum :position, { gardien: 0, defenseur: 1, milieu: 2, attaquant: 3, polyvalent: 4 }, default: :polyvalent
  enum :status, { unavailable: 0, rented: 1, available: 2 }, default: :available

  def self.by_position(requested_position)
    if requested_position == "all"
      all
    elsif positions.key?(requested_position)
      where(position: requested_position)
    else
      none
    end
  end

  def update_availability_status!
    today = Date.current

    is_player_on_loan = Booking.where(player_id: self.id, status: :accepted)
                                .where(start_date: ..today)
                                .where(end_date: today..)
                                .exists?

    if is_player_on_loan
      unless self.rented?
        self.rented!
      end
    else
      unless self.available?
        self.available!
      end
    end
  end
end
