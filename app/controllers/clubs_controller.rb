# Clubs participants : liste publique et page de chaque club.
class ClubsController < ApplicationController
  def index
    # with_players_count : le nombre de joueurs vient de la même requête (pas de N+1) ;
    # includes(:dirigeant) : les dirigeants en une requête de plus, quel que soit le nombre de clubs ;
    # load : chargé une fois. Sinon @clubs.size ferait un COUNT groupé, qui renvoie un hash.
    @clubs = policy_scope(Club).with_players_count.includes(:dirigeant).order(:name).load
  end

  def show
    @club = Club.find(params[:id])
    authorize @club
    @players = @club.players.includes(:club).sorted_by(Player::DEFAULT_SORT).load
  end
end
