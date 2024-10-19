if Rails.env.production?
  # Fetch Elasticsearch configuration from environment variables
  elasticsearch_host = ENV['ELASTICSEARCH_HOST']
  elasticsearch_username = ENV['ELASTICSEARCH_USERNAME']
  elasticsearch_password = ENV['ELASTICSEARCH_PASSWORD']

  Rails.logger.debug "Elasticsearch host: #{elasticsearch_host}"
  Rails.logger.debug "Elasticsearch username: #{elasticsearch_username}"
  Rails.logger.debug "Elasticsearch password: #{elasticsearch_password}"

  # Configure the Elasticsearch client
  Searchkick.client = Elasticsearch::Client.new(
    url: elasticsearch_host,
    transport_options: {
      ssl: { verify: false }
    },
    user: elasticsearch_username,
    password: elasticsearch_password
  )
end
