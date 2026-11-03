class PlayersController < ApplicationController
  include PlayerPage

  before_action :set_player, only: [ :show, :edit, :update ]
  before_action :authenticate_user!, only: [ :edit, :update ]

  # Catalogue : recherche + poste + tri, tous dans l'URL (?q=…&position=…&sort=…).
  # Le formulaire cible la Turbo Frame « players » : seule la liste est remplacée.
  def index
    @positions = Player.positions.keys
    @filters = {
      q: params[:q].to_s.strip,
      position: params[:position].presence || "all",
      sort: params[:sort].presence || Player::DEFAULT_SORT
    }
    @players = policy_scope(Player).includes(:club)
                                   .by_position(@filters[:position])
                                   .search(@filters[:q])
                                   .sorted_by(@filters[:sort])
                                   .load # chargé une fois : le compteur et la liste s'en servent
  end

  def show
    authorize @player
    load_player_page(@player)
  end

  # Le club propriétaire règle le prix par jour et la disponibilité à la location.
  def edit
    authorize @player
  end

  def update
    authorize @player
    if @player.update(player_params)
      redirect_to @player, notice: "Fiche de #{@player.name} mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Champs modifiables par le club propriétaire. Le statut n'est accepté que s'il fait partie
  # des choix du propriétaire (jamais « loué », état dérivé), et pas pendant un prêt en cours.
  def player_params
    permitted = params.require(:player).permit(:price_per_day, :status)
    status_choice_allowed = !@player.rented? && Player::OWNER_SETTABLE_STATUSES.include?(permitted[:status])
    permitted.delete(:status) unless status_choice_allowed
    permitted
  end

  def set_player
    @player = Player.find(params[:id])
  end
end
