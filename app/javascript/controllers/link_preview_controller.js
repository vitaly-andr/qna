import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["linkPreview"]

    connect() {
        const url = this.element.dataset.url; // Получаем URL из data-атрибута
        this.fetchLinkPreview(url);
    }

    async fetchLinkPreview(url) {
        try {
            const response = await fetch(`https://api.microlink.io/?url=${encodeURIComponent(url)}`);
            const data = await response.json();

            if (data.status === "success") {
                this.renderPreview(data);
            } else {
                this.linkPreviewTarget.innerHTML = "Failed to load preview";
            }
        } catch (error) {
            console.error("Error fetching Microlink preview:", error);
            this.linkPreviewTarget.innerHTML = "Error fetching preview";
        }
    }

    renderPreview(data) {
        this.linkPreviewTarget.innerHTML = `
      <div class="microlink_card">
        <img src="${data.data.image.url}" alt="${data.data.title}" />
        <h3>${data.data.title}</h3>
        <p>${data.data.description}</p>
        <a href="${data.data.url}" target="_blank">Read more</a>
      </div>
    `;
    }
}