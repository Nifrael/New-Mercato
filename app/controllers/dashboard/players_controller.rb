class Dashboard::PlayersController < Dashboard::BaseController
  before_action :set_club
  def index
    @players = @club.players
  end

  def loaned_out
    @loaned_out_players = @club.loaned_out_players.includes(:bookings)
  end

  def loaned_in
    @loaned_in_players = @club.loaned_in_players.includes(:bookings)
  end

  private

  def set_club
    @club = current_user.club
  end
end
