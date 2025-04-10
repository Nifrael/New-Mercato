import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.userClub = this.element.dataset.userClub;
    this.playerClub = this.element.dataset.playerClub;
    console.log("Club de l'utilisateur:", this.userClub);
    console.log("Club du joueur:", this.playerClub);

    // if (this.userClub === this.playerClub) {
    //   const button = document.getElementById("bookButton");
    //   button.disabled = true;
    //   button.value = "Déjà au club";
    // }
  }
}
