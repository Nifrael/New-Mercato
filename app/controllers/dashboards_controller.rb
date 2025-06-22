class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @club = current_user.club
    @players = @club.players
    @loaned_out_players = @club.loaned_out_players
    @loaned_in_players = @club.loaned_in_players
    @pending_negociations = @club.pending_negociations
  end
end
