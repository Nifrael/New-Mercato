import { Controller } from "@hotwired/stimulus"

// Soumet le formulaire automatiquement (filtres du catalogue).
// - submit      : tout de suite (pastille, menu de tri) ;
// - submitLater : après une pause de frappe (champ de recherche), pour ne pas
//   envoyer une requête à chaque lettre : c'est le « debounce ».
// Connects to data-controller="auto-submit"
export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  submit() {
    clearTimeout(this.timeout)
    // requestSubmit (et non submit) déclenche l'événement submit : Turbo peut l'intercepter.
    this.element.requestSubmit()
  }

  submitLater() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.submit(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
