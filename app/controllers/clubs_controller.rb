class ClubsController < ApplicationController
  def index
    @clubs = Club.all
  end

  def show
  end
end
