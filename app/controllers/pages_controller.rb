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
  end
end
