class Club < ApplicationRecord
  has_many :users
  # Le membre au rôle « dirigeant ». Association (et non méthode) pour pouvoir
  # la précharger avec includes(:dirigeant) et éviter les requêtes N+1.
  has_one :dirigeant, -> { dirigeant }, class_name: "User"
  has_many :players
  has_many :bookings
  has_many :booked_players, through: :bookings

  validates :name, presence: true, uniqueness: true
  validates :stadium, :logo, presence: true

  # Effectif actuel : nos joueurs qui ne sont pas prêtés + les joueurs empruntés.
  # La notion de « prêt en cours » vient de Booking.active, via les deux méthodes ci-dessous.
  def current_squad
    own_players = players.where.not(id: loaned_out_players.select(:id))

    Player.where(id: own_players.select(:id))
          .or(Player.where(id: loaned_in_players.select(:id)))
  end

  def loaned_out_players
    @loaned_out_players = self.players
                            .joins(:bookings)
                            .merge(Booking.active)
                            .where.not(bookings: { club_id: self.id })
                            .distinct
  end

  def loaned_in_players
    @loaned_in_players = Player.where.not(club: self)
                            .joins(:bookings)
                            .merge(Booking.active)
                            .where(bookings: { club: self })
                            .distinct
  end

  def sent_pending_bookings
    self.bookings.where(status: :pending)
  end

  def received_pending_bookings
    Booking.where(status: :pending)
            .where(player_id: self.player_ids)
            .where.not(club_id: self.id)
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
