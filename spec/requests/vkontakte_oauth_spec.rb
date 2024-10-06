require 'rails_helper'

RSpec.describe 'VKontakte OAuth2', type: :request do
  before do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
                                                                     provider: 'vkontakte',
                                                                     uid: '123456',
                                                                     info: {
                                                                       name: 'Test User',
                                                                       email: nil
                                                                     },
                                                                     credentials: {
                                                                       token: 'mock_token',
                                                                       refresh_token: 'mock_refresh_token',
                                                                       expires_at: Time.now + 1.week
                                                                     }
                                                                   })
  end

  it 'authenticates the user via VKontakte and generates a temporary email if not provided' do
    get '/users/auth/vkontakte/callback'

    expect(response).to redirect_to(root_path)

    follow_redirect!

    expected_email = '123456@vkontakte.com'
    expect(response.body).to include("Logged in as #{expected_email}")

    expect(flash[:notice]).to include('VKontakte')
  end

  it 'redirects to registration page if user is not persisted' do
    allow(User).to receive(:from_omniauth).and_return(User.new)

    get '/users/auth/vkontakte/callback'

    expect(response).to redirect_to(new_user_registration_url)
    follow_redirect!
    expect(response.body).to include('Authentication failed.')
  end
end
