module BadgesHelper
  # Variante visuelle de chaque statut (classe CSS badge--<variante>).
  # Un statut absent de cette table s'affiche en badge neutre.
  STATUS_VARIANTS = {
    booking: { pending: :warning, accepted: :success, refused: :danger },
    player: { available: :success, rented: :warning, unavailable: :danger }
  }.freeze

  # Badge du statut d'un enregistrement, libellé traduit via fr.yml.
  #   status_badge(booking) # => <span class="badge badge--warning">En attente</span>
  def status_badge(record)
    model = record.model_name.i18n_key
    variant = STATUS_VARIANTS.dig(model, record.status.to_sym)

    tag.span t("activerecord.enums.#{model}.status.#{record.status}"),
             class: [ "badge", ("badge--#{variant}" if variant) ]
  end

  # Compte à rebours d'un prêt : « J-8 », en avertissement quand la fin approche.
  def days_left_badge(booking)
    variant = booking.days_left <= 3 ? :warning : :success
    tag.span "J-#{booking.days_left}", class: [ "badge", "badge--#{variant}" ]
  end
end
