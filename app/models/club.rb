class Club < ApplicationRecord
  has_many :users
  has_many :players
  has_many :bookings
  has_many :booked_players, through: :bookings

  validates :name, presence: true, uniqueness: true
  validates :stadium, :logo, presence: true

  def current_squad
    today = Date.current

    players_out_ids = Player.joins(:bookings).where(club_id: self.id)
                                              .where(bookings: { status: :accepted })
                                              .where("bookings.club_id != ?", self.id)
                                              .where({ start_date: ..today })
                                              .where({ end_date: today.. })
                                              .distinct
                                              .pluck(:id)

    available_permanent_players = self.player.where.not(id: players_out_ids).load

    active_in_bookings = Booking.includes(:player).where(club_id: self.id)
                                              .where(status: :accepted)
                                              .where(start_date: ..today)
                                              .where(end_date: today..)

    loaned_in_players = active_in_bookings.map(&:player).compact

    entire_squad = (available_permanent_players + loaned_in_players).uniqueness

    entire_squad
  end
end
