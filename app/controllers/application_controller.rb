class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Disponible dans les vues (pastille de la navigation), sans requête écrite dans la vue.
  helper_method :pending_requests_count

  private

  # Demandes reçues en attente pour le club de l'utilisateur (0 pour un visiteur).
  # Mémorisé : une seule requête COUNT par page, même si la vue l'appelle plusieurs fois.
  def pending_requests_count
    return 0 unless user_signed_in? && current_user.club

    @pending_requests_count ||= current_user.club.received_pending_bookings.count
  end

  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action ou accéder à cette section."
    redirect_back(fallback_location: accueil_path)
  end
end
