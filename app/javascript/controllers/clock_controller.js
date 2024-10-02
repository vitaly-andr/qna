import { Controller } from "@hotwired/stimulus"
import moment from "moment"
import "moment-timezone"

export default class extends Controller {
    connect() {
        // Ваш код для виджета часов
        console.log(moment().format())
    }
}
