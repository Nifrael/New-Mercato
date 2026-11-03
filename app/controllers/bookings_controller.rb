class BookingsController < ApplicationController
  include PlayerPage

  before_action :authenticate_user!
  before_action :set_player, only: [ :create ]

  def show
    @booking = Booking.find(params[:id])
    authorize @booking
  end
  def create
    @booking = Booking.new(booking_params)
    @booking.player = @player
    @booking.club_id = current_user.club.id
    @booking.total_price = @booking.calculate_total_price(@player.price_per_day)
    authorize @booking
    if @booking.save
      redirect_to player_booking_path(player_id: @booking.player.id, id: @booking.id)
    else
      flash.now[:alert] = @booking.errors.full_messages.to_sentence
      load_player_page(@player, booking: @booking) # garde la saisie pour la corriger
      render "players/show", status: :unprocessable_entity
    end
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
