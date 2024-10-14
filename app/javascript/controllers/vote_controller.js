import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import debounce from "lodash.debounce"

export default class extends Controller {
    static targets = ["input", "results"]

    connect() {
    }

    search = debounce(async (event) => {
        const query = this.inputTarget.value

        if (query.length > 2) {
            await this.performSearch(query)
        } else {
            this.clearResults()
        }
    }, 300)

    async performSearch(query) {
        const response = await get(`/search.json?query=${query}`)

        if (response.ok) {
            const data = await response.json
            this.updateResults(data)
        } else {
            this.clearResults()
        }
    }

    updateResults(data) {
        this.resultsTarget.innerHTML = ""

        data.results.forEach(result => {
            const div = document.createElement("div")
            div.innerHTML = `<a href="${result.url}">${result.title}</a>`
            this.resultsTarget.appendChild(div)
        })
    }

    clearResults() {
        this.resultsTarget.innerHTML = ""
    }
}
