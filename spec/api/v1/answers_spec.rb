require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/answers', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let!(:answer) { answers.last }

      before { get '/api/v1/answers', format: :json, access_token: access_token.token, id: question.id }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end      

      %w(id body created_at updated_at).each do |attr| 
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers/0', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/answers/0', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:comment){ create(:comment, commentable: answer, user: user) }
      let!(:attachment){ create(:attachment, attachmentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns one answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr| 
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr| 
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file/url")
        end
      end
    end
  end

describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/answers', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }

      context 'valid data' do

        before { post "/api/v1/answers",format: :json, access_token: access_token.token, answer: attributes_for(:answer), id: question.id }

        it 'saves answer in db' do
          expect { post "/api/v1/answers",format: :json, access_token: access_token.token, answer: attributes_for(:answer), id: question.id }.to change(Answer, :count).by(1)
        end

        it 'belongs to user' do
          expect(Answer.last.user_id).to eq(user.id)
        end

        it 'belongs to question' do
          expect(assigns(:answer).question_id).to eq(question.id)
        end

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end
      end

      context 'invalid data' do
        it 'not saves answer in db' do
          expect { post "/api/v1/answers",format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer), id: question.id }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do 
          post "/api/v1/answers",format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer), id: question.id
          expect(response.status).to eq 422
        end
      end
    end
  end
end