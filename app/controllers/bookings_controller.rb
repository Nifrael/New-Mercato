class BookingsController < ApplicationController
  before_action :set_player, only: [:new, :create, :show, :edit, :update]

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.player = @player
    @user_id = current_user.id
    @booking.user_id = @user_id
    @booking.total_price = @booking.calculate_total_price(@player.price_per_day)
    if @booking.save
      redirect_to player_booking_path(player_id: @booking.player.id, id: @booking.id), notice: "Réservation effectuée avec succès."
    else
      flash.now[:alert] = "La réservation n'a pas pu être effectuée car le joueur appartient déjà à votre club."
      render "players/show", status: :unprocessable_entity
    end
  end

  def edit
    @booking = @player.bookings.find(params[:id])
  end

  def update
    @booking = @player.bookings.find(params[:id])
    @booking.player = @player
    @user_id = current_user.id
    @booking.total_price = @booking.calculate_total_price(@player.price_per_day)
    @booking.start_date = params[:start_date]
    @booking.end_date = params[:end_date]
    @booking.update(booking_params)
    redirect_to player_booking_path(@player, @booking)
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :user_id, :player_id, :total_price)
  end
end
