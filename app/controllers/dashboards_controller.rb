class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @club = current_user.club
    @players = @club.players
    @bookings = @club.bookings.includes(:players)
    @loaned = Player.where(players: { club: @club }).joins(:bookings).where.not(club: @club)
    bookings_table = Booking.arel_table
    players_table = Player.arel_table
    @sent_offers = bookings_table[:club_id].eq(@club.id)
    @received_offers = players_table[:club_id].eq(@club.id).and(bookings_table[:club_id].not_eq(@club.id))
    @negociations = Booking.joins(:player).where(status: :pending).where(@sent_offers.or(@received_offers))
  end
end
