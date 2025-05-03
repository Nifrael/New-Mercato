class Dashboard::BookingsController < Dashboard::BaseController
  before_action :find_and_authorize_booking, only: %i[show accept refuse]
  before_action :authorize_management, only: %i[accept refuse]

  def index
    current_club = current_user.club
    @pending_bookings = Booking.includes(:player, :club).where(status: :pending).where(players: { club_id: current_club.id })
    @bookings = Booking.includes(:player).where(club_id: current_club.id)
  end

  def show
  end

  def accept
    if @booking.may_accept?
      begin
        @booking.accept!
        redirect_to dashboard_bookings_path, notice: "Réservation pour '#{@booking.player.name}' acceptée."
      rescue => e
        Rails.logger.error "Erreur lors de l'acceptation Booking #{@booking.id}: #{e.message}."
        redirect_to dashboard_bookings_path, alert: "Une erreur est survenue lors de l'acceptation : #{e.message}"
      end
    else
      redirect_to dashboard_bookings_path, alert: "Cette réservation ne peut plus être acceptée (état actuel: #{@booking.status})."
    end
  end

  def refuse
    if @booking.may_refuse?
      begin
        @booking.refuse!
        redirect_to dashboard_bookings_path, notice: "Réservation pour '#{@booking.player.name}' refusée."
      rescue AASM::InvalidTransition => e
         redirect_to dashboard_bookings_path, alert: "Erreur de transition d'état: #{e.message}"
      rescue => e
        Rails.logger.error "Erreur lors du refus Booking ##{@booking.id}: #{e.message}."
        redirect_to dashboard_bookings_path, alert: "Une erreur est survenue lors du refus : #{e.message}"
      end
    else
      redirect_to dashboard_bookings_path, alert: "Cette réservation ne peut plus être refusée (état actuel: #{@booking.status})."
    end
  end

  private

  def find_and_authorize_booking
    begin
      @booking = Booking.includes(:player, :club, player: :club).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to dashboard_bookings_path, alert: "Réservation introuvable."
    end

    current_club = current_user.club
    unless current_club == @booking.club || current_club == @booking.player.club
      redirect_to dashboard_bookings_path, alert: "Vous n'avez pas l'autorisation pour accéder à cette réservation."
    end
  end

  def authorize_management
    unless current_user.club == @booking.player.club
      redirect_to dashboard_bookings_path(@booking), alert: "Vous n'avez pas le droit de décision sur cette réservation."
    end
  end
end
