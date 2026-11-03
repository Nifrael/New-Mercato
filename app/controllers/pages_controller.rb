# Pages publiques : bienvenue (racine) et présentation de New Mercato.
class PagesController < ApplicationController
  def bienvenue
  end

  # Tout ce que la page affiche vient de l'appli réelle (pas de chiffres inventés).
  def accueil
    @clubs = policy_scope(Club).order(:name)
    @players_count = Player.count
  end
end
