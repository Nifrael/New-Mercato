class ClubsController < ApplicationController
  def index
    @clubs = policy_scope(Club)
  end

  def show
    @club = Club.find(params[:id])
    authorize @club
    @players = @club.players
  end
end
