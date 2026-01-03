import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    this.element.style.transition = "opacity 0.3s ease-out"
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
