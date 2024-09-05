require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, author: user) } # Добавляем автора

  before { login(user) }

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
    context 'Author tries to edit their answer' do
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

    context 'Non-author tries to edit the answer' do
      before { login(other_user) }

      it 'redirects to the question show view with alert' do
        get :edit, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to question
        expect(flash[:alert]).to eq 'You can edit only your own answers.'
      end
    end
  end

  describe 'PATCH #update' do
    context 'Author tries to update their answer with valid attributes' do
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

    context 'Non-author tries to update the answer' do
      before { login(other_user) }

      it 'does not update the answer' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'Updated body' } }
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 'redirects to the question show view with alert' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'Updated body' } }
        expect(response).to redirect_to question
        expect(flash[:alert]).to eq 'You can update only your own answers.'
      end
    end

    context 'with invalid attributes' do
      it 'does not update the answer' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer, :invalid) }
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders the edit view' do
        patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author tries to delete their answer' do
      let!(:question) { create(:question, author: user) }

      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to the question show view' do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to question
      end
    end

    context 'Non-author tries to delete the answer' do
      before { login(other_user) }
      let!(:question) { create(:question, author: user) }

      let!(:answer) { create(:answer, question: question, author: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to_not change(Answer, :count)
      end

      it 'redirects to the question show view with alert' do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to question
        expect(flash[:alert]).to eq 'You can delete only your own answers.'
      end
    end
  end
end
