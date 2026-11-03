# Données de la fiche joueur, partagées par :
# - PlayersController#show (affichage normal) ;
# - BookingsController#create (ré-affiche la fiche quand la demande est invalide).
module PlayerPage
  extend ActiveSupport::Concern

  private

  def load_player_page(player, booking: nil)
    @player = player
    @unavailabilities = player.upcoming_unavailabilities.includes(:club)
    @booking = booking || Booking.new(player: player, club: current_user&.club)
    # « Peut-il réserver ? » : décidé par la policy, pas par la vue.
    @can_book = user_signed_in? && policy(@booking).create?
  end
end
