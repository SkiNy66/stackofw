require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { FactoryGirl.create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in user }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit', js: true do
    before { sign_in user }
    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 're-render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'save question with user_id' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(question.user_id).to eq(user.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: FactoryGirl.attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update', js: true do
    sign_in_user

    context 'valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, id: question, question: FactoryGirl.attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render updated question' do
        patch :update, id: question, question: FactoryGirl.attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: nil, body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'Question_1'
        expect(question.body).to eq 'Question_text'
      end

      it 're-renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Autorized user' do
      before { sign_in(user) }

      it 'deletes question' do
        question
        expect { delete :destroy, id: question.id }.to change(user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Non-autorized user' do
      before { question }
      it 'tries to delete question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(0)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
