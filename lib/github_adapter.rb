module GithubAdapter
  class API
    GITHUB_API_URL = 'https://api.github.com/user/emails'

    def self.fetch_user_emails(token)
      headers = { Authorization: "token #{token}" }
      response = RestClient.get(GITHUB_API_URL, headers)
      JSON.parse(response.body).map { |email| email['email'] }
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "GitHub API Error: #{e.message}"
      []
    end
  end
end