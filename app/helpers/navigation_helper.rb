module NavigationHelper
  # Quelle navigation afficher ? Elle dépend de QUI visite, pas de la page :
  # - connecté → le shell de l'application (sidebar / barre d'onglets) sur toutes les pages ;
  # - visiteur → la barre du site en haut.
  # Seule exception : /accueil est la vitrine, elle garde la barre du site même connecté.
  def app_shell?
    user_signed_in? && !current_page?(accueil_path)
  end

  # Le lien mène-t-il à la page en cours ?
  # exact: true : seulement ce chemin (sinon aussi ses sous-pages : /players/12 pour /players).
  def current_nav?(path, exact: false)
    request.path == path || (!exact && request.path.start_with?("#{path}/"))
  end

  # Lien de la navigation de l'application : icône + libellé (+ pastille).
  # - short_label : libellé affiché dans la barre d'onglets mobile (place limitée) ;
  # - exact: voir current_nav?.
  def nav_link(label, path, icon:, short_label: label, badge: nil, exact: false)
    link_to path, class: "app-nav__link", aria: { current: ("page" if current_nav?(path, exact:)) } do
      safe_join([
        icon(icon),
        tag.span(label, class: "app-nav__label app-nav__label--full"),
        tag.span(short_label, class: "app-nav__label app-nav__label--short"),
        (tag.span(badge, class: "app-nav__badge") if badge.to_i.positive?)
      ])
    end
  end
end
