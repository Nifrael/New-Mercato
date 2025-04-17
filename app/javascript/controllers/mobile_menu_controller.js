import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mobile-menu"
export default class extends Controller {
  connect() {
    console.log("connecté");
  }
  static targets = ["menu", "openIcon", "closeIcon"];

  toggle() {
    this.menuTarget.classList.toggle("hidden");
    this.openIconTarget.classList.toggle("hidden");
    this.closeIconTarget.classList.toggle("hidden");
  }
}
