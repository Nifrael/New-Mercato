# Recalcule chaque jour le statut Loué / Disponible des joueurs (planifié dans config/recurring.yml).
#
# On ne regarde PAS seulement « les prêts qui commencent aujourd'hui ou ont fini hier » :
# si le job ne tourne pas un jour (serveur arrêté, environnement de dev…), ces joueurs
# resteraient « Loué » pour toujours. On compare plutôt l'état stocké à la réalité :
# tout joueur marqué Loué OU ayant un prêt en cours est recalculé. Le job est donc
# auto-réparateur : le relancer n'importe quand remet tout d'aplomb.
class UpdatePlayerAvailabilityJob < ApplicationJob
  queue_as :default

  def perform
    players = Player.rented.or(Player.where(id: Booking.active.select(:player_id)))
    count = 0

    players.find_each do |player|
      player.update_availability_status!
      count += 1
    end
    Rails.logger.info "UpdatePlayerAvailabilityJob : statut vérifié pour #{count} joueur(s)"
  end
end
