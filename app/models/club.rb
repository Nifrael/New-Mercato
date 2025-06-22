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

  def loaned_out_players
    @loaned_out_players = self.players
                            .joins(:bookings)
                            .merge(Booking.active)
                            .where.not(bookings: { club_id: self.id })
                            .distinct
  end

  def loaned_in_players
    @loaned_in_players = Player.where.not(club: @club)
                            .joins(:bookings)
                            .merge(Booking.active)
                            .where(bookings: { club: @club })
                            .distinct
  end

  def pending_negociations
    bookings_table = Booking.arel_table
    players_table = Player.arel_table

    sent_offers = bookings_table[:club_id].eq(self.id)
    received_offers = players_table[:club_id].eq(self.id)
                      .and(bookings_table[:club_id].not_eq(self.id))

    Booking.joins(:player).where(status: :pending).where(sent_offers.or(received_offers))
  end
end
