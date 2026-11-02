module IconsHelper
  # Tracés des icônes (style « trait », grille 24×24). Ajouter une icône = une ligne ici.
  ICONS = {
    dashboard: '<rect x="3" y="3" width="7" height="9" rx="1"/><rect x="14" y="3" width="7" height="5" rx="1"/><rect x="14" y="12" width="7" height="9" rx="1"/><rect x="3" y="16" width="7" height="5" rx="1"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>',
    inbox: '<path d="M3 13h5l1.5 3h5L16 13h5"/><path d="M5 5h14l2 8v6H3v-6z"/>',
    squad: '<path d="M12 3l9 5-9 5-9-5z"/><path d="M3 13l9 5 9-5"/>',
    shield: '<path d="M12 3l8 3v6c0 4.5-3.4 8-8 9-4.6-1-8-4.5-8-9V6z"/>',
    login: '<path d="M9 4H5v16h4"/><path d="M14 8l4 4-4 4M18 12H8"/>',
    logout: '<path d="M15 4h4v16h-4"/><path d="M10 8l-4 4 4 4M6 12h11"/>'
  }.freeze

  # Icône décorative en SVG inline : elle prend la couleur du texte (currentColor).
  #   icon(:search) # => <svg …><circle …/><path …/></svg>
  def icon(name, size: 20)
    tag.svg ICONS.fetch(name).html_safe,
            class: "icon", width: size, height: size, viewBox: "0 0 24 24",
            fill: "none", stroke: "currentColor", "stroke-width": 1.8,
            "stroke-linecap": "round", "stroke-linejoin": "round", "aria-hidden": true
  end
end
