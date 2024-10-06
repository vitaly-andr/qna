require 'rails_helper'

RSpec.describe 'GitHub OAuth2', type: :request do
  before do
    OmniAuth.config.test_mode = true

    # Manually create mock authentication data for GitHub OAuth2
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  provider: 'github',
                                                                  uid: '123456',
                                                                  info: {
                                                                    name: 'Test User',
                                                                    email: 'testuser@example.com'
                                                                  },
                                                                  credentials: {
                                                                    token: 'mock_token',
                                                                    refresh_token: 'mock_refresh_token',
                                                                    expires_at: Time.now + 1.week
                                                                  }
                                                                })

    stub_request(:get, 'https://api.github.com/user/emails')
      .with(headers: { 'Authorization' => 'token mock_token' })
      .to_return(status: 200, body: [
        { email: 'primary@example.com', primary: true },
        { email: 'secondary@example.com', primary: false }
      ].to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'authenticates the user via GitHub, fetches emails, and redirects' do
    get '/users/auth/github/callback'

    expect(response).to redirect_to(root_path)

    follow_redirect!

    expect(response.body).to include('Logged in as primary@example.com')
  end
end
