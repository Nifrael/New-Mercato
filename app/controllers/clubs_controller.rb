class ClubsController < ApplicationController
  def index
    @clubs = Club.order(:name)
  end

  def show
    @players = Club.find(params[:id]).players
  end
end
