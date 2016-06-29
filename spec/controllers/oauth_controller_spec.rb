require 'rails_helper'

RSpec.describe OauthController, type: :controller do
  describe 'GET #new_email_for_oauth' do
    it 'render template :new_email_for_oauth' do
      get :new_email_for_oauth
      expect(response).to render_template :new_email_for_oauth
    end
  end

  describe 'POST #save_email_for_oauth' do
    before do
      session['devise.oauth_data'] = { provider: 'twitter', uid: '123456' }
    end

    context 'with valid data' do
      it 'assigns user to User' do
        post :save_email_for_oauth, email: 'email1@test.com'

        expect(assigns(:user)).to be_a(User)
      end

      it 'redirect_to new_user_session_path' do
        post :save_email_for_oauth, email: 'email@test.com'

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with invalid data' do
      it 'redirect_to new_email_for_oauth' do
        post :save_email_for_oauth, email: ''

        expect(response).to redirect_to :new_email_for_oauth
      end
    end
  end
end
