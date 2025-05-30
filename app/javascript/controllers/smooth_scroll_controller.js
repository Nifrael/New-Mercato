import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="smooth-scroll"
export default class extends Controller {
  connect() {
  }

  scrollToTarget(event) {
    event.preventDefault();
    const targetId = this.element.getAttribute("href").substring(1);
    console.log(targetId);
    const targetElement = document.getElementById(targetId);
    console.log(targetElement);

    window.scrollTo({
      top: targetElement.offsetTop,
      behavior: "smooth",
    });
  }
}
