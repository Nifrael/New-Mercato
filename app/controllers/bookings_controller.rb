class BookingsController < ApplicationController
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

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :club_id, :player_id, :total_price, :status)
  end
end
