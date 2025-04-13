class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
  end

  def edit
  end

  def update
  end
end
