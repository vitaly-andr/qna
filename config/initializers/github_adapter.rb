require 'github_adapter'

options = {request: {
  open_timeout: 5,
  timeout: 15
}}



connection = Faraday.new(url: "https://api.github.com", **options) do |faraday|
  faraday.response :raise_error
  faraday.request :json
  faraday.response :json, parser_options: {symbolize_names: true}
  faraday.response :logger, Rails.logger, {headers: false, bodies: true} do |logger|
    logger.filter(/("(?:username|password|epin)":)("[^"]+)/, '\1[REMOVED]')
  end
end

GithubAdapter::API.connection = connection