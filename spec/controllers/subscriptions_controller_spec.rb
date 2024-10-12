require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, subscribable: question, user: user) }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid subscribable' do
      it 'creates a new subscription' do
        expect {
          post :create, params: { question_id: question.id }, format: :turbo_stream
        }.to change(question.subscriptions, :count).by(1)
      end

      it 'renders turbo stream response' do
        post :create, params: { question_id: question.id }, format: :turbo_stream
        expect(response.content_type).to eq 'text/vnd.turbo-stream.html; charset=utf-8'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { subscription }

    it 'destroys the subscription' do
      expect {
        delete :destroy, params: { question_id: question.id }, format: :turbo_stream
      }.to change(question.subscriptions, :count).by(-1)
    end

    it 'renders turbo stream response' do
      delete :destroy, params: { question_id: question.id }, format: :turbo_stream
      expect(response.content_type).to eq 'text/vnd.turbo-stream.html; charset=utf-8'
    end
  end
end
