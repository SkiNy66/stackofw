require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let!(:answer) { answers.last }

      before { do_request(access_token: access_token.token, id: question.id) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answers object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/answers', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }

      before { do_request(access_token: access_token.token) }

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
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }
      let!(:object){ 'answer' }

      it_behaves_like "API Creatable"

      it 'belongs to question' do
        do_request(answer: attributes_for(:answer), access_token: access_token.token,)
        expect(assigns(:answer).question_id).to eq(question.id)
      end

      def do_request(options = {})
        post '/api/v1/answers', { format: :json, id: question.id }.merge(options)
      end
    end

    def do_request(options = {})
      post '/api/v1/answers', { format: :json }.merge(options)
    end
  end
end
