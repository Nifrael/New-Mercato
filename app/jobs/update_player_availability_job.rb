# Recalcule chaque jour le statut des joueurs dont un prêt COMMENCE aujourd'hui (→ Loué)
# ou s'est TERMINÉ hier (→ Disponible). Planifié dans config/recurring.yml.
class UpdatePlayerAvailabilityJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.current
    loans = Booking.accepted.where(start_date: today).or(Booking.accepted.where(end_date: today - 1))
    player_ids = loans.distinct.pluck(:player_id)

    Player.where(id: player_ids).find_each(&:update_availability_status!)
    Rails.logger.info "UpdatePlayerAvailabilityJob : statut recalculé pour #{player_ids.size} joueur(s)"
  end
end
