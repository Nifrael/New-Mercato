# Pages publiques : bienvenue (racine) et présentation de New Mercato.
class PagesController < ApplicationController
  def bienvenue
  end

  # Tout ce que la page affiche vient de l'appli réelle (pas de chiffres inventés).
  def accueil
    @clubs = policy_scope(Club).order(:name)
    @players_count = Player.count
    # Vitrine : les joueurs disponibles les plus cotés, comme le tri par défaut du catalogue.
    @featured_players = policy_scope(Player).available.includes(:club)
                                            .sorted_by(Player::DEFAULT_SORT).limit(4)
    @story_booking = story_booking(@featured_players.first)
  end

  private

  # Location racontée sur l'accueil : construite en mémoire, JAMAIS enregistrée (pas de save).
  # Vrai joueur, vrai club emprunteur, vrai calcul du total : l'exemple ne peut pas mentir.
  def story_booking(player)
    borrower = player && @clubs.detect { |club| club.id != player.club_id }
    return unless borrower

    start_date = Date.current.next_occurring(:monday)
    booking = Booking.new(player:, club: borrower, start_date:, end_date: start_date + 21)
    booking.total_price = booking.calculate_total_price(player.price_per_day)
    booking
  end
end
