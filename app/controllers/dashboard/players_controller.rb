# Effectif du club, en trois vues reliées par des onglets :
# effectif actuel (index), joueurs prêtés (loaned_out), joueurs empruntés (loaned_in).
class Dashboard::PlayersController < Dashboard::BaseController
  before_action :set_club_and_tabs

  def index
    @players = @club.current_squad.includes(:club).sorted_by(Player::DEFAULT_SORT)
  end

  def loaned_out
    @loans = @club.lent_loans.includes(:club, player: :club).order(:end_date)
  end

  def loaned_in
    @loans = @club.borrowed_loans.includes(:club, player: :club).order(:end_date)
  end

  private

  # Espace du club : même règle d'accès que le tableau de bord (DashboardPolicy).
  def set_club_and_tabs
    authorize :dashboard, :show?
    @club = current_user.club
    @tab_counts = {
      squad: @club.current_squad.count,
      loaned_out: @club.lent_loans.count,
      loaned_in: @club.borrowed_loans.count
    }
  end
end
