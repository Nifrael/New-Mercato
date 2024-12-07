class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def index
    @user = current_user
    @players = Player.where(club_id: current_user.club.id).sorted_by_position
    @bookings = current_user.bookings
    @today = Date.today
    @gardiens = Player.where(club_id: current_user.club.id).where(position: "Gardien")
    @defenseurs = Player.where(club_id: current_user.club.id).where(position: "Défenseur")
    @milieux = Player.where(club_id: current_user.club.id).where(position: "Milieu")
    @attaquants = Player.where(club_id: current_user.club.id).where(position: "Attaquant")
  end
end
