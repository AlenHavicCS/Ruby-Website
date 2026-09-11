import { Controller } from "@hotwired/stimulus"

// Types out each word in wordsValue, pauses, deletes it, then moves to the next.
export default class extends Controller {
  static targets = ["word"]
  static values = {
    words: Array,
    typeSpeed: { type: Number, default: 70 },
    deleteSpeed: { type: Number, default: 40 },
    pauseTime: { type: Number, default: 1500 },
  }

  connect() {
    this.wordIndex = 0
    this.charIndex = 0
    this.deleting = false
    this.tick()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  tick() {
    const current = this.wordsValue[this.wordIndex]
    this.charIndex += this.deleting ? -1 : 1
    this.wordTarget.textContent = current.slice(0, this.charIndex)

    let delay = this.deleting ? this.deleteSpeedValue : this.typeSpeedValue

    if (!this.deleting && this.charIndex === current.length) {
      this.deleting = true
      delay = this.pauseTimeValue
    } else if (this.deleting && this.charIndex === 0) {
      this.deleting = false
      this.wordIndex = (this.wordIndex + 1) % this.wordsValue.length
    }

    this.timeout = setTimeout(() => this.tick(), delay)
  }
}
