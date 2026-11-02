# Catalogue des composants (route absente en production, cf. config/routes.rb).
# Exception assumée à la règle « toute action appelle authorize » :
# page d'outillage sans aucune donnée de l'application, inaccessible en production.
class StyleguideController < ApplicationController
  def show
    # Enregistrements construits en mémoire (jamais sauvegardés) pour afficher les badges.
    @booking_statuses = Booking.statuses.keys.map { |status| Booking.new(status: status) }
    @player_statuses = Player.statuses.keys.map { |status| Player.new(status: status) }
  end
end
