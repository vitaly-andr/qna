# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"


pin "@creativebulma/bulma-collapsible", to: "@creativebulma--bulma-collapsible.js" # @1.0.4

pin "moment" # @2.30.1
pin "moment-timezone" # @0.5.45
