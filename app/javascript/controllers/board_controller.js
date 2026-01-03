import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["columnsContainer", "addColumnButton", "addColumnForm"]
  static values = { id: Number }

  connect() {
    // Initialize board
  }

  showAddColumn() {
    this.addColumnButtonTarget.classList.add("hidden")
    this.addColumnFormTarget.classList.remove("hidden")
    this.addColumnFormTarget.querySelector("input")?.focus()
  }

  hideAddColumn() {
    this.addColumnButtonTarget.classList.remove("hidden")
    this.addColumnFormTarget.classList.add("hidden")
    this.addColumnFormTarget.querySelector("form")?.reset()
  }
}
