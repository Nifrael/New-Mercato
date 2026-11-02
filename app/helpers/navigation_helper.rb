module NavigationHelper
  # Lien de la navigation principale : icône + libellé (+ pastille).
  # - short_label : libellé affiché dans la barre d'onglets mobile (place limitée) ;
  # - exact: true : actif seulement sur ce chemin exact (sinon aussi sur ses sous-pages,
  #   ex. « Joueurs » reste actif sur /players/12).
  def nav_link(label, path, icon:, short_label: label, badge: nil, exact: false)
    active = request.path == path || (!exact && request.path.start_with?("#{path}/"))

    link_to path, class: "app-nav__link", aria: { current: ("page" if active) } do
      safe_join([
        icon(icon),
        tag.span(label, class: "app-nav__label app-nav__label--full"),
        tag.span(short_label, class: "app-nav__label app-nav__label--short"),
        (tag.span(badge, class: "app-nav__badge") if badge.to_i.positive?)
      ])
    end
  end
end
