import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header", "editForm", "nameInput", "addCardButton", "addCardForm", "cardsContainer"]
  static values = { id: Number, boardId: Number }

  connect() {
    // Initialize column
  }

  startEditing() {
    this.headerTarget.classList.add("hidden")
    this.editFormTarget.classList.remove("hidden")
    this.nameInputTarget.focus()
    this.nameInputTarget.select()
  }

  stopEditing() {
    this.headerTarget.classList.remove("hidden")
    this.editFormTarget.classList.add("hidden")
  }

  showAddCard() {
    this.addCardButtonTarget.classList.add("hidden")
    this.addCardFormTarget.classList.remove("hidden")
    this.addCardFormTarget.querySelector("textarea")?.focus()
  }

  hideAddCard() {
    this.addCardButtonTarget.classList.remove("hidden")
    this.addCardFormTarget.classList.add("hidden")
    this.addCardFormTarget.querySelector("form")?.reset()
  }

  submitCard(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.addCardFormTarget.querySelector("form")?.requestSubmit()
    }
  }
}
