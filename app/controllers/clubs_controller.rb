class ClubsController < ApplicationController
  def index
    @clubs = Club.order(:name)
  end

  def show
  end
end
