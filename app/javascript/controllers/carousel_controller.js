import { Controller } from "@hotwired/stimulus"

// Instagram-style photo carousel: native horizontal scroll-snap handles
// touch swiping, this controller just keeps the dots/arrows in sync.
export default class extends Controller {
  static targets = ["track", "dots", "lightbox", "lightboxImage"]

  connect() {
    this.onScroll = this.onScroll.bind(this)
    this.trackTarget.addEventListener("scroll", this.onScroll, { passive: true })
  }

  disconnect() {
    this.trackTarget.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    clearTimeout(this.scrollTimeout)
    this.scrollTimeout = setTimeout(() => this.updateActiveDot(), 80)
  }

  updateActiveDot() {
    if (!this.hasDotsTarget) return

    const index = this.currentIndex()
    this.dotsTarget.querySelectorAll(".carousel-dot").forEach((dot, i) => {
      dot.classList.toggle("active", i === index)
    })
  }

  currentIndex() {
    const track = this.trackTarget
    return Math.round(track.scrollLeft / track.clientWidth)
  }

  prev() {
    this.scrollToIndex(this.currentIndex() - 1)
  }

  next() {
    this.scrollToIndex(this.currentIndex() + 1)
  }

  goTo(event) {
    this.scrollToIndex(Number(event.currentTarget.dataset.index))
  }

  scrollToIndex(index) {
    const track = this.trackTarget
    const max = track.children.length - 1
    const clamped = Math.min(Math.max(index, 0), max)
    track.scrollTo({ left: clamped * track.clientWidth, behavior: "smooth" })
  }

  openLightbox(event) {
    this.lightboxImageTarget.src = event.currentTarget.dataset.url
    this.lightboxTarget.showModal()
  }

  closeLightbox() {
    this.lightboxTarget.close()
  }

  backdropClose(event) {
    if (event.target === this.lightboxTarget) this.lightboxTarget.close()
  }
}
