class Booking < ApplicationRecord
  include AASM

  belongs_to :player
  belongs_to :club

  PERIOD_UNAVAILABLE = "Ce joueur est déjà loué sur une partie de cette période.".freeze
  PLAYER_NOT_FOR_LOAN = "Ce joueur n'est pas proposé à la location pour le moment.".freeze

  enum :status, { accepted: 0, pending: 1, refused: 2 }, default: :pending

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :accepted
    state :refused

    # after sur l'ÉVÉNEMENT (et non sur la transition) : exécuté APRÈS l'enregistrement du
    # nouveau statut, donc la location est bien vue comme acceptée lors du recalcul.
    event :accept, after: :refresh_player_status do
      # guard : la transition n'est possible que si la période est encore libre
      # (sinon may_accept? renvoie false et accept! est refusé).
      transitions from: :pending, to: :accepted, guard: :period_available?
    end

    event :refuse do
      transitions from: :pending, to: :refused
    end
  end

  validates :start_date, :end_date, :total_price, presence: true

  validate :validate_time
  validate :player_already_in_club, on: :create
  validate :period_must_be_available, on: :create
  validate :player_must_be_for_loan, on: :create

  scope :active, -> { where(status: :accepted).where("start_date <= :today AND end_date >= :today", today: Date.current) }

  # Réservations qui ont au moins un jour en commun avec [from, to] (bornes incluses) :
  # elles commencent avant la fin de la période ET finissent après son début.
  scope :overlapping, ->(from, to) { where("start_date <= :to AND end_date >= :from", from: from, to: to) }

  # Vrai si aucune AUTRE location acceptée du même joueur ne chevauche cette période.
  # Les demandes en attente ne bloquent pas : plusieurs clubs peuvent demander les mêmes dates.
  def period_available?
    return true if start_date.blank? || end_date.blank?

    !Booking.accepted.where(player_id: player_id).where.not(id: id).overlapping(start_date, end_date).exists?
  end

  def calculate_total_price(price_per_day)
    return if start_date.blank? || end_date.blank?

    duration_in_days * price_per_day
  end

  # --- États dérivés des dates (calculés, jamais stockés) ---------------------

  # Nombre de jours facturés : du 1er au 15 → 14 jours.
  def duration_in_days
    (end_date - start_date).to_i
  end

  # Jours avant la fin du prêt (0 une fois terminé).
  def days_left
    [ (end_date - Date.current).to_i, 0 ].max
  end

  # Avancement du prêt en %, borné entre 0 (pas commencé) et 100 (terminé).
  def progress_percent
    elapsed = (Date.current - start_date).to_i
    (elapsed * 100 / duration_in_days).clamp(0, 100)
  end

  private

  def validate_time
    # Dates manquantes : déjà signalées par `validates ... presence: true`.
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "doit être postérieure à la date de début.") if start_date >= end_date
  end

  def period_must_be_available
    errors.add(:base, PERIOD_UNAVAILABLE) unless period_available?
  end

  def player_must_be_for_loan
    errors.add(:base, PLAYER_NOT_FOR_LOAN) if player&.unavailable?
  end

  def player_already_in_club
    if player.club_id == club_id
      errors.add(:base, "Ce joueur appartient déjà à votre club, vous ne pouvez pas le réserver.")
    end
  end

  # Le joueur n'est « Loué » que si le prêt a déjà commencé (sinon le job le fera le jour J).
  def refresh_player_status
    player.update_availability_status!
  end
end
