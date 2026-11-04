import { Controller } from "@hotwired/stimulus"

// Affiche en direct le nombre de jours et le total d'une demande de location.
// Purement informatif : le serveur recalcule toujours le vrai total.
// Connects to data-controller="booking-total"
export default class extends Controller {
  static targets = ["start", "end", "days", "total"]
  static values = { price: Number }

  static DAY_IN_MS = 24 * 60 * 60 * 1000
  static currency = new Intl.NumberFormat("fr-FR", { style: "currency", currency: "EUR", maximumFractionDigits: 0 })

  connect() {
    this.update() // valeurs déjà présentes (ré-affichage après une erreur)
  }

  update() {
    const start = this.startTarget.valueAsDate
    const end = this.endTarget.valueAsDate

    // La fin ne peut pas précéder le lendemain du début : on guide le sélecteur natif.
    if (start) this.endTarget.min = this.#isoDate(new Date(start.getTime() + this.constructor.DAY_IN_MS))

    if (!start || !end || end <= start) {
      this.daysTarget.textContent = "0"
      this.totalTarget.textContent = "—"
      return
    }

    const days = Math.round((end - start) / this.constructor.DAY_IN_MS)
    this.daysTarget.textContent = days
    this.totalTarget.textContent = this.constructor.currency.format(days * this.priceValue)
  }

  #isoDate(date) {
    return date.toISOString().slice(0, 10)
  }
}
