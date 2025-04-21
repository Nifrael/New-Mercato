class PlayersController < ApplicationController
  def index
    @positions = Player.positions.key
    @players = Player.all
  end

  def filter_by_position
    if params[:position].present?
      @players = Player.by_position(params[:position])
    else
      @players = Player.all
    end
    render partial: "player_card", collection: @players, as: :player
  end

  def show
  end

  def edit
  end

  def update
  end
end
