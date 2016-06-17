require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe "GET #facebook" do
    let(:user) { create(:user) }
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exit' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'facebook', uid: '123456', info: { email: 'new-user@email.com' } })
        get :facebook
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end 
    end

    context 'user without authorizations' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'facebook', uid: '123456', info: { email: user.email } })
        get :facebook
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end
    end

    context 'user with authorizations' do
      let(:auth){ create(:authorization, user: user) }
      
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: auth.provider, uid: auth.uid, info: { email: user.email } })
        get :facebook
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end
    end
  end

  describe "GET #twitter" do
    let(:user) { create(:user) }
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exit' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '123456', info: { email: 'new-user@email.com' } })
        get :twitter
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end 
    end

    context 'user without authorizations' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '123456', info: { email: user.email } })
        get :twitter
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end
    end

    context 'user with authorizations' do
      let(:auth){ create(:authorization, user: user) }
      
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: auth.provider, uid: auth.uid, info: { email: user.email } })
        get :twitter
      end

      it 'assigns user to User' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'user signed in' do
        should be_user_signed_in
      end
    end

    context 'email nil' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '123456', info: { email: nil } })
        get :twitter
      end

      it { should_not be_user_signed_in }
      it { should redirect_to new_email_for_oauth_path }
    end
  end
end