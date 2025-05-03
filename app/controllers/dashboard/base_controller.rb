module Dashboard
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_club_association

    private

    def require_club_association
      if current_user.club.nil?
        redirect_to accueil_path, alert: "Vous devez avoir un rôle dans un club afin d'accéder à cette page."
      end
    end
  end
end
