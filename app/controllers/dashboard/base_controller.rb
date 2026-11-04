# Espace du club connecté. L'accès est vérifié dans chaque action par Pundit
# (DashboardPolicy, BookingPolicy), qui exigent un utilisateur rattaché à un club.
module Dashboard
  class BaseController < ApplicationController
    before_action :authenticate_user!
  end
end
