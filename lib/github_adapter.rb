module GithubAdapter
  class API

    class_attribute :connection

    def self.fetch_user_emails(token)
      headers = { Authorization: "token #{token}"}
      response = connection.get("/user/emails", nil, headers)
      response.body.map { |email| email[:email] }
    rescue Faraday::Error => e
      Rails.logger.error "GitHub API Error: #{e.message}"
      []
    end


  end
end