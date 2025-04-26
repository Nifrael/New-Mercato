class PlayersController < ApplicationController
  before_action :set_player, only: [ :show, :edit, :update ]
  def index
    @positions = Player.positions.keys
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
    @booking = Booking.new
  end

  def edit
  end

  def update
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end
end
