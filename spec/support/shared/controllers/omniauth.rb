shared_examples_for "Omniauthable" do
  context 'user does not exit' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: "#{provider}", uid: '123456', info: { email: 'new-user@email.com' } })
      get :"#{provider}"
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
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: "#{provider}", uid: '123456', info: { email: user.email } })
      get :"#{provider}"
    end

    it 'assigns user to User' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'user signed in' do
      should be_user_signed_in
    end
  end

  context 'user with authorizations' do
    let(:auth) { create(:authorization, user: user) }

    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: auth.provider, uid: auth.uid, info: { email: user.email } })
      get :"#{provider}"
    end

    it 'assigns user to User' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'user signed in' do
      should be_user_signed_in
    end
  end
end