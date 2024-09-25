import { Controller } from "@hotwired/stimulus"
import { post, destroy } from "@rails/request.js"

export default class extends Controller {
    static targets = ["rating", "errorMessage"]

    upvote() {
        this.vote(1)
    }

    downvote() {
        this.vote(-1)
    }

    async vote(value) {
        const votableId = this.element.dataset.voteVotableId
        const votableType = this.element.dataset.voteVotableType

        try {
            const response = await post(`/votes`, {
                body: JSON.stringify({ value: value, votable_type: votableType, votable_id: votableId }),
                contentType: "application/json",
                responseKind: "json"
            })

            if (response.ok) {
                const data = await response.json
                this.ratingTarget.textContent = data.rating
                this.clearErrorMessage()
            } else {
                const data = await response.json
                this.handleError(data.error)
            }
        } catch (error) {
            console.error("Error while voting:", error)
        }
    }

    async cancelVote() {
        const votableId = this.element.dataset.voteVotableId
        const votableType = this.element.dataset.voteVotableType

        try {
            const response = await destroy(`/votes`, {
                body: JSON.stringify({ votable_type: votableType, votable_id: votableId }),
                contentType: "application/json",
                responseKind: "json"
            })

            if (response.ok) {
                const data = await response.json
                this.ratingTarget.textContent = data.rating
                this.clearErrorMessage()
            } else {
                const data = await response.json
                this.handleError(data.error)
            }
        } catch (error) {
            console.error("Error while cancelling vote:", error)
        }
    }
    handleError(message) {
        this.errorMessageTarget.textContent = message
        this.errorMessageTarget.classList.add('visible')
        alert(message)

    }

    clearErrorMessage() {
        this.errorMessageTarget.textContent = "" // Очищаем сообщение
        this.errorMessageTarget.classList.remove('visible') // Убираем класс видимости
    }
}
