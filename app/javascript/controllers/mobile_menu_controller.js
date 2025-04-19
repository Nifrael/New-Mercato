import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mobile-menu"
export default class extends Controller {
  static targets = ["button", "tabs"];

  toggle() {
    this.tabsTarget.classList.toggle("opened");
    this.tabsTarget.classList.toggle("min-h-screen");
    this.buttonTarget.classList.toggle("active");
    document.body.classList.toggle("no-scroll");
  }
}
