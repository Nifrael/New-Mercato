class Player < ApplicationRecord
  belongs_to :club
  has_many :bookings

  enum :position, { gardien: 0, defenseur: 1, milieu: 2, attaquant: 3, polyvalent: 4 }, default: :polyvalent
  enum :status, { unavailable: 0, rented: 1, available: 2 }, default: :available

  # Statuts que le club propriétaire peut choisir lui-même. « rented » (loué) n'en fait pas
  # partie : c'est un état DÉRIVÉ des locations acceptées, jamais choisi à la main.
  OWNER_SETTABLE_STATUSES = %w[available unavailable].freeze

  # only_integer vérifie la valeur SAISIE (avant conversion) : 12.5 est refusé,
  # au lieu d'être silencieusement arrondi à 12 par la colonne entière.
  validates :price_per_day, numericality: { only_integer: true, greater_than: 0 }

  # Prix par jour proposé à l'import : un an de location = la valeur marchande.
  # Au moins 1 € : en division entière, une petite valeur donnerait 0 (location gratuite).
  def self.price_per_day_for(market_value)
    [ market_value / 365_000, 1 ].max
  end

  def self.by_position(requested_position)
    if requested_position == "all"
      all
    elsif positions.key?(requested_position)
      where(position: requested_position)
    else
      none
    end
  end

  # Tris proposés dans le catalogue. Liste FERMÉE : un paramètre d'URL n'est jamais
  # injecté dans un ORDER BY (injection SQL) ; une clé inconnue prend le tri par défaut.
  SORTS = {
    "value" => { market_value: :desc },
    "price" => { price_per_day: :asc },
    "age" => { age: :asc }
  }.freeze
  DEFAULT_SORT = "value".freeze

  # Recherche insensible à la casse (ILIKE, PostgreSQL) sur le nom, la nationalité et le club.
  # sanitize_sql_like échappe % et _ : « % » est cherché tel quel, pas comme joker.
  # La valeur passe par un paramètre nommé (:q), jamais concaténée dans le SQL.
  def self.search(query)
    return all if query.blank?

    pattern = "%#{sanitize_sql_like(query.strip)}%"
    joins(:club).where("players.name ILIKE :q OR players.nationality ILIKE :q OR clubs.name ILIKE :q", q: pattern)
  end

  def self.sorted_by(key)
    order(SORTS.fetch(key.to_s, SORTS[DEFAULT_SORT]))
  end

  # Périodes où le joueur est déjà loué (locations acceptées pas encore terminées),
  # de la plus proche à la plus lointaine.
  def upcoming_unavailabilities
    bookings.accepted.where(end_date: Date.current..).order(:start_date)
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
