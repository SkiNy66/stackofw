require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /users' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token) }

      before { get '/api/v1/profiles/users', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'does not contains current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'contains all users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "every user contains #{attr}" do
          users.each_with_index do |user, a|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{a}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "every userdoes not contains #{attr}" do
          users.each_with_index do |user, a|
            expect(response.body).to_not have_json_path("#{a}/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/users', { format: :json }.merge(options)
    end
  end
end
