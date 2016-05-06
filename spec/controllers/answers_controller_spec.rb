require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }
  # let(:answer) { FactoryGirl.create(:answer) }
  describe 'GET #new' do
    before do
      get :new, question_id: question
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save answer for question' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show question with answers' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'not save answer for question' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end
end
