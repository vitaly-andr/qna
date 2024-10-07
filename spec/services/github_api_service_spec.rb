require 'rails_helper'

RSpec.describe GithubAdapter::API do
  let(:token) { 'mock_token' }

  describe '#fetch_user_emails' do
    subject(:fetch_user_emails) { described_class.fetch_user_emails(token) }

    context 'when the request is successful' do
      before do
        stub_request(:get, 'https://api.github.com/user/emails')
          .with(headers: { 'Authorization' => "token #{token}" })
          .to_return(status: 200, body: '[{"email": "primary@example.com"}]', headers: {'Content-Type': 'application/json'})
      end

      it 'returns the emails' do
        expect(fetch_user_emails).to eq(['primary@example.com'])
      end
    end

    context 'when the request fails' do
      before do
        stub_request(:get, 'https://api.github.com/user/emails')
          .with(headers: { 'Authorization' => "token #{token}" })
          .to_return(status: 500)
      end

      it 'logs the error and returns an empty array' do
        expect(fetch_user_emails).to eq([])
      end
    end
  end
end
