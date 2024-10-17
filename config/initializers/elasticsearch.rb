if Rails.env.production?
  Searchkick.client = Elasticsearch::Client.new(
    url: Rails.application.credentials.dig(:elasticsearch, :host),
    transport_options: {
      ssl: { verify: false } # Временно отключаем проверку сертификата
    },
    user: Rails.application.credentials.dig(:elasticsearch, :username),
    password: Rails.application.credentials.dig(:elasticsearch, :password)
  )
else
  # Development and test configuration
  Searchkick.client = Elasticsearch::Client.new(
    url: ENV['ELASTICSEARCH_URL'] || 'https://localhost:9200',
    transport_options: {
      ssl: { verify: false }
    },
    user: 'elastic',
    password: ENV['ELASTICSEARCH_PASSWORD']
  )
end