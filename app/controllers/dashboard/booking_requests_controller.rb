class Dashboard::BookingRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: %i[accept refuse]

  def index
    current_club = current_user.club
    @pending_bookings = Booking.includes(:player, :club).where(status: :pending).where(players: { club_id: current_club.id })
  end

  def show
  end

  def accept
    if @booking.may_accept?
      begin
        @booking.accept!
        redirect_to dashboard_booking_requests_path, notice: "Réservation pour '#{@booking.player.name}' acceptée."
      rescue => e
        Rails.logger.error "Erreur lors de l'acceptation Booking #{@booking.id}: #{e.message}."
        redirect_to dashboard_booking_requests_path, alert: "Une erreur est survenue lors de l'acceptation : #{e.message}"
      end
    else
      redirect_to dashboard_booking_requests_path, alert: "Cette réservation ne peut plus être acceptée (état actuel: #{@booking.status})."
    end
  end

  def refuse
    if @booking.may_refuse?
      begin
        @booking.refuse!
        redirect_to dashboard_booking_requests_path, notice: "Réservation pour '#{@booking.player.name}' refusée."
      rescue AASM::InvalidTransition => e
         redirect_to dashboard_booking_requests_path, alert: "Erreur de transition d'état: #{e.message}"
      rescue => e
        Rails.logger.error "Erreur lors du refus Booking ##{@booking.id}: #{e.message}."
        redirect_to dashboard_booking_requests_path, alert: "Une erreur est survenue lors du refus : #{e.message}"
      end
    else
      redirect_to dashboard_booking_requests_path, alert: "Cette réservation ne peut plus être refusée (état actuel: #{@booking.status})."
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
