require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to the question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders the new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'GET #edit' do
    before do
      get :edit, params: { id: answer.id, question_id: question.id }
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders the :edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the answer' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'Updated body' } }
        answer.reload
        expect(answer.body).to eq 'Updated body'
      end

      it 'redirects to the question show view' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'Updated body' } }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not update the answer' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders the edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end
