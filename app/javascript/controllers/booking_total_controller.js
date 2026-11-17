import { Controller } from "@hotwired/stimulus"

// Formulaire de demande de location :
// - affiche en direct le nombre de jours et le total ;
// - prévient dès la saisie si les dates chevauchent une période déjà louée, et bloque l'envoi.
// Purement informatif : le serveur recalcule toujours le vrai total et revalide la période
// (Booking#period_available?). Sans JavaScript, c'est lui qui affiche l'erreur.
// Connects to data-controller="booking-total"
export default class extends Controller {
  static targets = ["start", "end", "days", "total", "conflict"]
  static values = {
    price: Number,
    taken: Array,           // périodes déjà louées : [["2026-11-16", "2026-11-22"], …]
    conflictMessage: String // texte de Booking::PERIOD_UNAVAILABLE (écrit une seule fois, côté Ruby)
  }

  static DAY_IN_MS = 24 * 60 * 60 * 1000
  static currency = new Intl.NumberFormat("fr-FR", { style: "currency", currency: "EUR", maximumFractionDigits: 0 })

  connect() {
    this.update() // valeurs déjà présentes (ré-affichage après une erreur)
  }

  update() {
    this.#checkAvailability()
    this.#updateTotal()
  }

  // Même règle que le scope Booking.overlapping : début ≤ fin louée ET fin ≥ début loué.
  // Les dates sont comparées en texte « AAAA-MM-JJ » : l'ordre alphabétique est l'ordre
  // chronologique, et on évite tout décalage de fuseau horaire des objets Date.
  #checkAvailability() {
    const start = this.startTarget.value
    const end = this.endTarget.value || start // une seule date choisie : on la vérifie déjà
    const taken = start !== "" && this.takenValue.some(([from, to]) => start <= to && end >= from)
    const message = taken ? this.conflictMessageValue : ""

    // Message non vide → champ invalide : le navigateur refuse d'envoyer le formulaire.
    this.startTarget.setCustomValidity(message)
    this.conflictTarget.textContent = message
  }

  #updateTotal() {
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
