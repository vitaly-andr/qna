import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["links", "template"]

    addLink(event) {
        event.preventDefault()

        const uniqueId = new Date().getTime()

        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, uniqueId)

        this.linksTarget.insertAdjacentHTML('beforeend', content)
    }

    removeLink(event) {
        event.preventDefault()

        document.getElementById(event.target.dataset.linkId)?.remove()
    }
}
