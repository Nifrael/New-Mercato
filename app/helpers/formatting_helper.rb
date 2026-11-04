module FormattingHelper
  COMPACT_CURRENCY_UNITS = { unit: "€", thousand: "k€", million: "M€", billion: "Md€" }.freeze

  # Montant abrégé pour les chiffres clés : 300_000_000 → « 300 M€ », 1_500_000 → « 1,5 M€ ».
  # Pour un montant exact (prix, total d'une réservation), utiliser number_to_currency.
  def compact_currency(amount)
    number_to_human(amount, units: COMPACT_CURRENCY_UNITS, format: "%n %u", precision: 3)
  end
end
