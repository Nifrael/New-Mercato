class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @club = current_user.club
    @players = @club.players
    @bookings = @club.bookings.includes(:players)
    @loaned = Booking.joins(:player).where(players: { club: @club }).where.not(club: @club)
    @sent_offers = Booking.where(club: @club, status: :pending)
    # @received_offers = Booking.where()
    # @negociations = @sent_offers.or(@received_offers)
  end
end
