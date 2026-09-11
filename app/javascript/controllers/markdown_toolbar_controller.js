import { Controller } from "@hotwired/stimulus"

// Lightweight formatting toolbar for a textarea: wraps/prefixes the
// current selection with the description renderer's mini-markdown
// syntax (see ProjectsHelper#formatted_description).
export default class extends Controller {
  static targets = ["textarea"]

  bold() {
    this.wrapSelection("**", "**")
  }

  italic() {
    this.wrapSelection("*", "*")
  }

  heading() {
    this.toggleLinePrefix("## ")
  }

  alignLeft() {
    this.setAlign("left")
  }

  alignCenter() {
    this.setAlign("center")
  }

  alignRight() {
    this.setAlign("right")
  }

  wrapSelection(before, after) {
    const ta = this.textareaTarget
    const start = ta.selectionStart
    const end = ta.selectionEnd
    const value = ta.value
    const selected = value.slice(start, end) || "text"

    ta.value = value.slice(0, start) + before + selected + after + value.slice(end)
    ta.focus()
    ta.selectionStart = start + before.length
    ta.selectionEnd = start + before.length + selected.length
  }

  toggleLinePrefix(prefix) {
    const ta = this.textareaTarget
    const start = ta.selectionStart
    const value = ta.value
    const lineStart = value.lastIndexOf("\n", start - 1) + 1
    const lineEndIndex = value.indexOf("\n", start)
    const lineEnd = lineEndIndex === -1 ? value.length : lineEndIndex
    const line = value.slice(lineStart, lineEnd)
    const newLine = line.startsWith(prefix) ? line.slice(prefix.length) : prefix + line

    ta.value = value.slice(0, lineStart) + newLine + value.slice(lineEnd)
    ta.focus()
    const delta = newLine.length - line.length
    ta.selectionStart = ta.selectionEnd = start + delta
  }

  setAlign(align) {
    const ta = this.textareaTarget
    const start = ta.selectionStart
    const value = ta.value
    const paraStart = this.paragraphStart(value, start)
    const markerPattern = /^\[align:(left|center|right)\]\n/
    const rest = value.slice(paraStart)
    const match = rest.match(markerPattern)
    const marker = `[align:${align}]\n`

    const without = match ? rest.slice(match[0].length) : rest
    ta.value = value.slice(0, paraStart) + marker + without
    ta.focus()
    ta.selectionStart = ta.selectionEnd = start + marker.length - (match ? match[0].length : 0)
  }

  paragraphStart(value, position) {
    const blankLineIndex = value.lastIndexOf("\n\n", position - 1)
    return blankLineIndex === -1 ? 0 : blankLineIndex + 2
  }
}
