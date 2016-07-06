require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    before do
    end

    context 'with valid attributes' do
      context 'question' do
        it 'save comment' do
          sign_in(user)
          expect { post :create, commentable: 'question', question_id: question, user_id: user.id, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
        end

        it 'render template :create' do
          sign_in(user)
          post :create, commentable: 'question', question_id: question, comment: attributes_for(:comment), format: :js
          expect(response).to render_template :create
        end

        it 'save comment with user_id' do
          sign_in(user)
          post :create, commentable: 'question', question_id: question, user_id: user.id, comment: attributes_for(:comment), format: :js
          expect(Comment.last.user_id).to eq(user.id)
        end

        it 'publish message to channel PrivatePub' do
          sign_in(user)
          expect(PrivatePub).to receive(:publish_to).with("/comments", anything)
          post :create, commentable: 'question', question_id: question, user_id: user.id, comment: attributes_for(:comment), format: :js
        end
      end

      context 'answer' do
        it 'save comment' do
          sign_in(user)
          expect { post :create, commentable: 'answer', answer_id: answer.id, user_id: user.id, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
        end

        it 'render template :create' do
          sign_in(user)
          post :create, commentable: 'answer', answer_id: answer.id, comment: attributes_for(:comment), format: :js
          expect(response).to render_template :create
        end

        it 'save comment with user_id' do
          sign_in(user)
          post :create, commentable: 'answer', answer_id: answer.id, user_id: user.id, comment: attributes_for(:comment), format: :js
          expect(Comment.last.user_id).to eq(user.id)
        end

        it 'publish message to channel PrivatePub' do
          sign_in(user)
          expect(PrivatePub).to receive(:publish_to).with("/comments", anything)
          post :create, commentable: 'answer', answer_id: answer.id, user_id: user.id, comment: attributes_for(:comment), format: :js
        end
      end
    end

    context 'with invalid attributes' do
      it 'not save comment for question' do
        expect { post :create, commentable: 'question', question_id: question, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
      end

      it 'dont publish message to channel PrivatePub' do
        sign_in(user)
        expect(PrivatePub).to_not receive(:publish_to).with("/comments", anything)
        post :create, commentable: 'question', question_id: question, user_id: user.id, comment: attributes_for(:invalid_comment), format: :js
      end

      it 'not save comment for answer' do
        expect { post :create, commentable: 'answer', answer_id: answer.id, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
      end

      it 'dont publish message to channel PrivatePub' do
        expect(PrivatePub).to_not receive(:publish_to).with("/comments", anything)
        post :create, commentable: 'answer', answer_id: answer.id, user_id: user.id, comment: attributes_for(:invalid_comment), format: :js
      end
    end
  end
end
