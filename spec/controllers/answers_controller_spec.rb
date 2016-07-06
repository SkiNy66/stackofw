require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, user: user) }
  let(:answer) { FactoryGirl.create(:answer, question: question, user: user) }
  let(:answer2) { FactoryGirl.create(:answer, question: question, user: user2) }

  describe 'POST #create' do
    before do
      sign_in(user)
    end

    context 'with valid attributes' do
      it 'save answer for question' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render empty' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
        expect(response.body).to eq '' # expect(response).to render_template :create
      end

      it 'save answer for question with user_id' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
        expect(answer.user_id).to eq(user.id)
      end

      it 'publish message to channel PrivatePub' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{ question.id }/answers", anything)
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
      end
    end

    context 'with invalid attributes' do
      it 'not save answer for question' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to show question with answers' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js

        expect(response).to render_template :create
      end

      it 'dont publish message to channel PrivatePub' do
        expect(PrivatePub).to_not receive(:publish_to)
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js
      end
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in(user)
    end

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context 'Autorized user' do
      it 'Delete answer' do
        sign_in(user)
        answer
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        sign_in(user)
        delete :destroy, id: answer, question_id: question, format: :js

        expect(response).to render_template :destroy
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

  describe 'PATCH #set_best' do
    context 'Author of question' do
      before { sign_in(user) }
      before { patch :mark_best, id: answer, format: :js }

      it 'changes answer best attributes' do
        answer.reload

        expect(answer.best).to eq true
      end

      it 'render set_best template' do
        expect(response).to render_template :mark_best
      end
    end

    context 'Non-author of question' do
      before { sign_in(user2) }
      before { patch :mark_best, id: answer.id, format: :js }

      it 'tries to change best answer' do
        expect(answer.best).to eq false
      end
    end
  end

  describe 'Likes' do
    let!(:object){ answer }
    let!(:object2){ answer2 }

    it_behaves_like "Likable"
  end
end
