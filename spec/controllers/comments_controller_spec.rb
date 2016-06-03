require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  # let(:comment) { create(:comment, user: user, commentable: question) }

  describe 'POST #create' do
    before do
      
    end

    context 'with valid attributes' do
      it 'save comment for question' do
        sign_in(user)
        expect { post :create, question_id: question, user_id: user.id, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render template :create' do
        sign_in(user)
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end

      it 'save comment for question with user_id' do
        sign_in(user)
        post :create, question_id: question, user_id: user.id, comment: attributes_for(:comment), format: :js
        expect(Comment.last.user_id).to eq(user.id)
      end
    end

    context 'with invalid attributes' do
      it 'not save comment for question' do
        expect { post :create, question_id: question, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
      end

      it 'redirect to show question with answers' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create 
      end
    end
  end
end