class UpdatePlayerAvailabilityJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "--- [JOB START] UpdatePlayerAvailabilityJob : Recherche bookings terminés hier ---"
    yesterday = Date.yesterday

    ended_bookings = Booking.where(status: :accepted, end_date: yesterday.all_day).includes(:player)

    if ended_bookings.empty?
      puts "--- [JOB INFO] Aucun booking pertinent terminé le #{yesterday}. Fin."
      return
    end

    puts "--- [JOB INFO] Trouvé #{ended_bookings.count} booking(s). Traitement des joueurs... IDs: #{ended_bookings.map(&:player_id).uniq.compact} ---"
    player_ids = ended_bookings.pluck(:player_id).uniq.compact

    Player.where(id: player_ids).find_each do |player|
      puts "--- [JOB DETAIL] Traitement Joueur ##{player.id} (Statut actuel: #{player.status}) ---"
      begin
        player.update_availability_status!
        puts "--- [JOB DETAIL] Joueur ##{player.id} => Nouveau statut: #{player.status} ---"
      rescue => e
        error_message = "ERREUR MAJ Joueur ##{player.id}: #{e.message}"
        puts "--- [JOB ERROR] #{error_message} ---"
        Rails.logger.error "UpdatePlayerAvailabilityJob: #{error_message}"
      end
    end
    puts "--- [JOB END] UpdatePlayerAvailabilityJob: Terminé. ---"
  end
end
