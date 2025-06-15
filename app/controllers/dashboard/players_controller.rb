class Dashboard::PlayersController < Dashboard::BaseController
  before_action :set_club
  def index
    @players = @club.players
  end

  def loaned_out
    @loaned_out_players = Player.where(club: @club).joins(:bookings).where.not(bookings: { club: @club }).distinct
  end

  def loaned_in
    @loaned_in_players = Player.where.not(club: @club).joins(:bookings).where(bookings: { club: @club }).distinct
  end

  private

  def set_club
    @club = current_user.club
  end
end
