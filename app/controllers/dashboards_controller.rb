class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @club = current_user.club
    @players = @club.players
    @bookings = @club.bookings.includes(:players)
  end
end
