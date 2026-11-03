class Dashboard::BookingsController < Dashboard::BaseController
  before_action :set_booking, only: %i[accept refuse]

  # Ordre des colonnes du pipeline.
  PIPELINE_STATUSES = %w[pending accepted refused].freeze

  # Pipeline des demandes : reçues (par défaut) ou envoyées (?direction=sent),
  # rangées par statut. Toute autre valeur de direction retombe sur « reçues ».
  def index
    authorize Booking, :index?
    @direction = params[:direction] == "sent" ? :sent : :received

    club = current_user.club
    bookings = @direction == :sent ? club.bookings : club.received_bookings
    bookings = policy_scope(bookings).includes(:club, player: :club).order(:start_date)

    by_status = bookings.group_by(&:status)
    @columns = PIPELINE_STATUSES.index_with { |status| by_status.fetch(status, []) }
  end

  def accept
    authorize @booking, :update?
    if @booking.may_accept?
      @booking.accept!
      redirect_back_or_to dashboard_bookings_path, notice: "Réservation pour « #{@booking.player.name} » acceptée."
    else
      redirect_back_or_to dashboard_bookings_path, alert: accept_refusal_message
    end
  end

  def refuse
    authorize @booking, :update?
    if @booking.may_refuse?
      @booking.refuse!
      redirect_back_or_to dashboard_bookings_path, notice: "Réservation pour « #{@booking.player.name} » refusée."
    else
      redirect_back_or_to dashboard_bookings_path, alert: "Cette réservation ne peut plus être refusée (statut : #{status_label})."
    end
  end

  private

  # Les droits d'accès sont vérifiés dans chaque action par `authorize` (BookingPolicy).
  # Réservation inexistante : find lève RecordNotFound, que Rails transforme en 404.
  def set_booking
    @booking = Booking.includes(:club, player: :club).find(params[:id])
  end

  # Une demande encore en attente qu'on ne peut pas accepter : sa période est déjà louée
  # (garde AASM). Sinon, elle a déjà été traitée.
  def accept_refusal_message
    return Booking::PERIOD_UNAVAILABLE if @booking.pending?

    "Cette réservation ne peut plus être acceptée (statut : #{status_label})."
  end

  def status_label
    t("activerecord.enums.booking.status.#{@booking.status}")
  end
end
