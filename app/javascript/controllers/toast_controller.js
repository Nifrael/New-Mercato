import { Controller } from "@hotwired/stimulus"

// Toast d'un message flash : se ferme tout seul après `duration` ms, ou au clic sur ×.
// Connects to data-controller="toast"
export default class extends Controller {
  static values = { duration: { type: Number, default: 5000 } }

  connect() {
    this.timeout = setTimeout(() => this.dismiss(), this.durationValue)
  }

  // Toujours nettoyer le minuteur : sinon il continuerait de tourner
  // après que Turbo a retiré l'élément de la page (fuite mémoire, erreur).
  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    clearTimeout(this.timeout)
    this.element.classList.add("toast--leaving")
    // On attend la fin de l'animation de sortie avant de retirer l'élément.
    // Sans animation (prefers-reduced-motion), aucun animationend : on retire tout de suite.
    const animated = getComputedStyle(this.element).animationName !== "none"
    if (animated) {
      this.element.addEventListener("animationend", () => this.element.remove(), { once: true })
    } else {
      this.element.remove()
    }
  }
}
