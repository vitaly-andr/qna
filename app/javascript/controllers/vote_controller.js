import { Controller } from "@hotwired/stimulus"
import { patch, del } from "@rails/request.js"

export default class extends Controller {
    static targets = ["rating"]

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
            const response = await patch(`/votes`, {
                body: JSON.stringify({ value: value, votable_type: votableType, votable_id: votableId }),
                contentType: "application/json",
                responseKind: "json"
            })

            if (response.ok) {
                const data = await response.json()
                this.ratingTarget.textContent = data.rating
            } else {
                const data = await response.json()
                alert(data.error)
            }
        } catch (error) {
            console.error("Error while voting:", error)
        }
    }

    async cancelVote() {
        const votableId = this.element.dataset.voteVotableId
        const votableType = this.element.dataset.voteVotableType

        try {
            const response = await del(`/votes`, {
                body: JSON.stringify({ votable_type: votableType, votable_id: votableId }),
                contentType: "application/json",
                responseKind: "json"
            })

            if (response.ok) {
                const data = await response.json()
                this.ratingTarget.textContent = data.rating
            } else {
                const data = await response.json()
                alert(data.error)
            }
        } catch (error) {
            console.error("Error while cancelling vote:", error)
        }
    }
}
