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

  # Prêts en cours concernant le club, dans les deux sens :
  # il emprunte (bookings.club_id) ou il prête (players.club_id).
  def active_loans
    loans = Booking.active.joins(:player)
    loans.where(club: self).or(loans.where(players: { club_id: id }))
  end

  def sent_pending_bookings
    self.bookings.where(status: :pending)
  end

  # Demandes reçues : réservations de NOS joueurs par d'autres clubs (tous statuts).
  # Une seule requête (jointure), au lieu de charger d'abord la liste des player_ids.
  def received_bookings
    Booking.joins(:player).where(players: { club_id: id }).where.not(club_id: id)
  end

  def received_pending_bookings
    received_bookings.pending
  end
end
