require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, user: user) }
  let(:answer) { FactoryGirl.create(:answer, question: question, user: user) }
  
  describe 'GET #new' do
    before do
      sign_in(user)
      get :new, question_id: question
    end

    it 'assigns a new answer for question' do
      sign_in(user)
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before do
      sign_in(user)
    end
      
    context 'with valid attributes' do
      it 'save answer for question' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show question with answers' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end       

      it 'save answer for question with user_id' do 
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        expect(answer.user_id).to eq(user.id)
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

  describe 'DELETE #destroy' do
    context 'Autorized user' do
      it 'Delete answer' do
        sign_in(user)
        answer
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end

      it 're-direct to index view' do
        sign_in(user)
        delete :destroy, id: answer, question_id: question

        expect(response).to redirect_to question
      end
    end

    context 'Non-autorized user' do
    it 'tries to delete answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(0)
      end

      it 're-direct to index view' do
        delete :destroy, id: answer, question_id: question

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
