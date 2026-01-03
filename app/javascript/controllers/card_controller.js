import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "modal"]
  static values = { id: Number }

  connect() {
    // Initialize card
  }

  showModal(event) {
    event.preventDefault()
    this.modalTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  hideModal() {
    this.modalTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }

  // Close modal on Escape key
  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.hideModal()
    }
  }
}
