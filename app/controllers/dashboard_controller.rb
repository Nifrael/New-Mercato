class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def index
    @user = current_user
    @players = Player.where(club_id: current_user.club.id).order(:position)
    @bookings = current_user.bookings
    @today = Date.today
    @gardiens = Player.where(club_id: current_user.club.id).where(position: 0)
    @defenseurs = Player.where(club_id: current_user.club.id).where(position: 1)
    @milieux = Player.where(club_id: current_user.club.id).where(position: 2)
    @attaquants = Player.where(club_id: current_user.club.id).where(position: 3)
  end
end
