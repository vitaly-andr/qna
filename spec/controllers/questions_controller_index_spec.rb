require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:questions) { create_list(:question, 5, author: user) }

  describe 'GET #index' do
    before do
      get :index
      puts "Created questions: #{Question.count}"
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders the :index view' do
      expect(response).to render_template :index
    end
  end
end
