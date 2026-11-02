module FlashHelper
  # Type de message flash (clé Rails) → variante visuelle du toast (classe toast--<variante>).
  FLASH_VARIANTS = { notice: :success, alert: :danger }.freeze

  def flash_variant(type)
    FLASH_VARIANTS[type.to_sym]
  end

  # Rôle ARIA : « alert » interrompt le lecteur d'écran → réservé aux erreurs ;
  # « status » annonce le message poliment, à la fin de la phrase en cours.
  def flash_role(type)
    flash_variant(type) == :danger ? "alert" : "status"
  end
end
