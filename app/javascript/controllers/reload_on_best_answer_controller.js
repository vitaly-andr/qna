import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["reloadArea"]

    connect() {
        const observer = new MutationObserver(() => {
            this.reloadPage();
        });

        observer.observe(this.reloadAreaTarget, { childList: true });
    }

    reloadPage() {
        window.location.reload();
    }
}