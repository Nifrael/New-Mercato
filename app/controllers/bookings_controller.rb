class BookingsController < ApplicationController
  before_action :set_player, only: [ :new, :create ]

  def show
    @booking = Booking.find(params[:id])
  end

  def new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.player = @player
    @booking.club_id = current_user.club.id
    @booking.total_price = @booking.calculate_total_price(@player.price_per_day)
    if @booking.save
      redirect_to player_booking_path(player_id: @booking.player.id, id: @booking.id), notice: "Réservation effectuée avec succès."
    else
      flash.now[:alert] = "La réservation est impossible car le joueur appartient déjà à votre club."
      render "players/show", status: :unprocessable_entity
    end
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :club_id, :player_id, :total_price, :status)
  end
end
