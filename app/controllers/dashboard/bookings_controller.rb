class Dashboard::BookingsController < Dashboard::BaseController
  before_action :set_booking, only: %i[show accept refuse]

  def index
    authorize Booking, :index?
    current_club = current_user.club
    sent_offers = current_club.sent_pending_bookings
    received_offers = current_club.received_pending_bookings
    @pending_bookings = policy_scope(received_offers).includes(:player)
    @bookings = policy_scope(sent_offers).includes(:player, :club)
  end

  def show
    authorize @booking
  end

  def accept
    authorize @booking, :update?
    if @booking.may_accept?
      @booking.accept!
      redirect_back_or_to dashboard_bookings_path, notice: "Réservation pour « #{@booking.player.name} » acceptée."
    else
      redirect_back_or_to dashboard_bookings_path, alert: "Cette réservation ne peut plus être acceptée (statut : #{status_label})."
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

  def status_label
    t("activerecord.enums.booking.status.#{@booking.status}")
  end
end
