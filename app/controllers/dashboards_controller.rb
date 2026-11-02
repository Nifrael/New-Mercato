# Tableau de bord du club : « qu'est-ce que je dois faire aujourd'hui ? »
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @club = current_user.club
    @squad_count = @club.current_squad.count
    @loaned_in_count = @club.loaned_in_players.count
    @loaned_out_count = @club.loaned_out_players.count
    # includes : chaque carte affiche le joueur ET le club → préchargés (pas de N+1).
    @requests_to_handle = @club.received_pending_bookings.includes(:club, :player).order(:start_date)
    @active_loans = @club.active_loans.includes(:club, player: :club).order(:end_date)
  end
end
