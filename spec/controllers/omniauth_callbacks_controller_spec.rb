require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }
  
  describe 'GET #facebook' do
    let(:provider){ 'facebook' }

    it_behaves_like "Omniauthable"
  end

  describe 'GET #twitter' do
    let(:provider){ 'twitter' }
    
    it_behaves_like "Omniauthable"

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
