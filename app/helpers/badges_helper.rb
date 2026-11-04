module BadgesHelper
  # Variante visuelle de chaque statut (classe CSS badge--<variante>).
  # Un statut absent de cette table s'affiche en badge neutre.
  STATUS_VARIANTS = {
    booking: { pending: :warning, accepted: :success, refused: :danger },
    player: { available: :success, rented: :warning, unavailable: :danger }
  }.freeze

  # Badge du statut d'un enregistrement, libellé traduit via fr.yml.
  #   status_badge(booking) # => <span class="badge badge--warning">En attente</span>
  # Variante d'un statut : status_variant(:booking, "pending") # => :warning
  # Partagée par les badges et les pastilles de colonnes du pipeline (une seule correspondance).
  def status_variant(model, status)
    STATUS_VARIANTS.dig(model, status.to_sym)
  end

  # status: affiche un autre statut que celui de l'enregistrement
  # (ex. l'accueil raconte la suite d'une demande : status_badge(booking, status: :accepted)).
  def status_badge(record, status: record.status)
    model = record.model_name.i18n_key
    variant = status_variant(model, status)

    tag.span t("activerecord.enums.#{model}.status.#{status}"),
             class: [ "badge", ("badge--#{variant}" if variant) ]
  end

  # Compte à rebours d'un prêt : « J-8 », en avertissement quand la fin approche.
  def days_left_badge(booking)
    variant = booking.days_left <= 3 ? :warning : :success
    tag.span "J-#{booking.days_left}", class: [ "badge", "badge--#{variant}" ]
  end
end
