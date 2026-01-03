import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    group: String,
    url: String
  }

  connect() {
    this.initializeSortable()
    this.observeNewCards()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  initializeSortable() {
    this.element.addEventListener("dragover", this.onDragOver.bind(this))
    this.element.addEventListener("drop", this.onDrop.bind(this))

    // Make children draggable
    this.makeChildrenDraggable()
  }

  // Watch for new cards added via Turbo Stream
  observeNewCards() {
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE && node.dataset.sortableId) {
            this.makeElementDraggable(node)
          }
        })
      })
    })

    this.observer.observe(this.element, { childList: true })
  }

  makeChildrenDraggable() {
    Array.from(this.element.children).forEach(child => {
      if (child.dataset.sortableId) {
        this.makeElementDraggable(child)
      }
    })
  }

  makeElementDraggable(element) {
    element.draggable = true
    element.addEventListener("dragstart", this.onDragStart.bind(this))
    element.addEventListener("dragend", this.onDragEnd.bind(this))
  }

  onDragStart(event) {
    const item = event.target.closest("[data-sortable-id]")
    if (!item) return

    item.classList.add("opacity-50")
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", JSON.stringify({
      id: item.dataset.sortableId,
      sourceColumnId: this.element.closest("[data-column-id-value]")?.dataset.columnIdValue
    }))
  }

  onDragEnd(event) {
    const item = event.target.closest("[data-sortable-id]")
    if (item) {
      item.classList.remove("opacity-50")
    }
  }

  onDragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"

    const draggingItem = document.querySelector("[data-sortable-id].opacity-50")
    if (!draggingItem) return

    const afterElement = this.getDragAfterElement(event.clientY)
    if (afterElement) {
      this.element.insertBefore(draggingItem, afterElement)
    } else {
      this.element.appendChild(draggingItem)
    }
  }

  onDrop(event) {
    event.preventDefault()

    let data
    try {
      data = JSON.parse(event.dataTransfer.getData("text/plain"))
    } catch (e) {
      console.error("Failed to parse drag data:", e)
      return
    }

    const cardId = data.id
    const sourceColumnId = data.sourceColumnId
    const targetColumnId = this.element.closest("[data-column-id-value]")?.dataset.columnIdValue

    // Calculate new position
    const items = Array.from(this.element.querySelectorAll("[data-sortable-id]"))
    const droppedItem = items.find(item => item.dataset.sortableId === cardId)
    const newPosition = droppedItem ? items.indexOf(droppedItem) : items.length

    // Update on server
    this.updatePosition(cardId, sourceColumnId, targetColumnId, newPosition)
  }

  getDragAfterElement(y) {
    const draggableElements = [...this.element.querySelectorAll("[data-sortable-id]:not(.opacity-50)")]

    return draggableElements.reduce((closest, child) => {
      const box = child.getBoundingClientRect()
      const offset = y - box.top - box.height / 2

      if (offset < 0 && offset > closest.offset) {
        return { offset: offset, element: child }
      } else {
        return closest
      }
    }, { offset: Number.NEGATIVE_INFINITY }).element
  }

  async updatePosition(cardId, sourceColumnId, targetColumnId, position) {
    const url = this.urlValue.replace(":id", cardId)
    const csrfToken = document.querySelector("[name='csrf-token']")?.content

    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({
          target_column_id: targetColumnId,
          position: position
        })
      })

      if (!response.ok) {
        console.error("Failed to update card position")
        window.location.reload()
      }
    } catch (error) {
      console.error("Error updating card position:", error)
      window.location.reload()
    }
  }
}
