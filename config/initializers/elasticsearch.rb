Searchkick.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'https://localhost:9200',
  transport_options: {
    ssl: { verify: false }
  },
  user: 'elastic',
  password: ENV['ELASTICSEARCH_PASSWORD']
)