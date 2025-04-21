import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="players-filter"
export default class extends Controller {
  static targets = ["list"];

  connect() {
    console.log("coucou");
  }

  filter(event) {
    event.preventDefault();
    const position = event.target.dataset.filterPosition;
    console.log(position);
    this.fetchPlayers(position);
  }

  fetchPlayers(position) {
    const url = `/players/filter_by_position?position=${position}`;

    fetch(url, {
      headers: {
        Accept: "text/html",
        "X-Requested-With": "XMLHttpRequest",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        this.listTarget.innerHTML = html;
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération des joueurs:", error);
      });
  }
}
