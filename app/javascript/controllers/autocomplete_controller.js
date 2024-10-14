import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search(event) {
    const query = this.inputTarget.value

    if (query.length > 2) {
      this.performSearch(query)
    } else {
      this.clearResults()
      this.showNoResultsMessage()
    }
  }

  updateResults(data) {
    this.resultsTarget.innerHTML = ""

    if (data.length > 0) {
      data.forEach(result => {
        if (!result.url) {
          console.error("Missing URL for result:", result)
          return
        }

        const div = document.createElement("div")

        if (result.type === "question") {
          div.innerHTML = `<a href="${result.url}">${result.title}</a>`
        } else if (result.type === "answer" || result.type === "comment") {
          div.innerHTML = `<a href="${result.url}">${result.body}</a>`
        } else {
          console.error('Unknown result type:', result)
          return
        }

        this.resultsTarget.appendChild(div)
      })

      this.clearNoResultsMessage()
    } else {
      this.showNoResultsMessage()
    }
  }


  clearNoResultsMessage() {
    const noResultsElement = document.getElementById('no-results')
    if (noResultsElement) {
      noResultsElement.style.display = 'none'
    }
  }

  showNoResultsMessage() {
    const noResultsElement = document.getElementById('no-results')
    if (noResultsElement) {
      noResultsElement.style.display = 'block'
    }
  }

  async performSearch(query) {
    const response = await fetch(`/search.json?query=${query}`)
    const data = await response.json()
    this.updateResults(data)
  }




  clearResults() {
    this.resultsTarget.innerHTML = ""
  }
}
