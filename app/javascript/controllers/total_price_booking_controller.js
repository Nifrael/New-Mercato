import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="total-price-booking"
export default class extends Controller {
  static targets = ["startDate", "endDate", "price", "pricePerDay", "button"];

  connect() {}

  priceCount(event) {
    event.preventDefault;
    let date1 = this.startDateTarget;
    let date2 = this.endDateTarget;
    let startDate = new Date(date1.value);
    let endDate = new Date(date2.value);
    let diffTime = Math.abs(endDate - startDate);
    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    let price = this.priceTarget;
    price.innerHTML = `Total ${diffDays} jours : <br><span>${(
      diffDays * this.pricePerDayTarget.innerText
    ).toLocaleString("fr-FR")} €</span>`;
    this.buttonTarget.classList.remove("disabled");
  }
}
