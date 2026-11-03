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

  def edit
    authorize @player
  end

  def update
    authorize @player
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end
end
