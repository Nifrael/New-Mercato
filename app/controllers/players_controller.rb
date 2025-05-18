class PlayersController < ApplicationController
  before_action :set_player, only: [ :show, :edit, :update ]
  before_action :authenticate_user!, only: [ :edit, :update ]

  def index
    @positions = Player.positions.keys
    @players = policy_scope(Player)
  end

  def filter_by_position
    base_scope = policy_scope(Player)
    if params[:position].present?
      @players = base_scope.by_position(params[:position])
    else
      @players = base_scope.all
    end
    render partial: "player_card", collection: @players, as: :player
  end

  def show
    authorize @player
    if user_signed_in?
      authorize Booking, :new?
      @booking = Booking.new
    end
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
