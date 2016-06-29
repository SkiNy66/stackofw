require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:authorizations).dependent(:destroy) }
  end

  context 'Validates' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        let(:auth_email_nil) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: '' }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authotization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authotization with provider and uid' do
          user = User.find_for_oauth(auth)
          authotization = user.authorizations.first

          expect(authotization.provider).to eq auth.provider
          expect(authotization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

        it 'returns nil if email blank' do
          expect(User.find_for_oauth(auth_email_nil)).to be_nil
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        let(:auth_email_nil) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: '' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns nil if email blank' do
          expect(User.find_for_oauth(auth_email_nil)).to be_nil
        end
      end
    end
  end
end
