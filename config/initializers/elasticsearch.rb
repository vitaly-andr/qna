if Rails.env.production?
  Rails.logger.debug "Elasticsearch host: #{Rails.application.credentials.dig(:elasticsearch, :host)}"
  Rails.logger.debug "Elasticsearch username: #{Rails.application.credentials.dig(:elasticsearch, :username)}"
  Rails.logger.debug "Elasticsearch password: #{Rails.application.credentials.dig(:elasticsearch, :password)}"

  Searchkick.client = Elasticsearch::Client.new(
    url: Rails.application.credentials.dig(:elasticsearch, :host),
    transport_options: {
      ssl: { verify: false }
    },
    user: Rails.application.credentials.dig(:elasticsearch, :username),
    password: Rails.application.credentials.dig(:elasticsearch, :password)
  )
end
