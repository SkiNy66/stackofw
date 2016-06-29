require 'acceptance_helper'

feature 'User can sign in with Facebook', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'sign up new user' do
    visit new_user_registration_path
    facebook_mock_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account'
  end

  scenario 'add authorization to user' do
    user
    visit new_user_registration_path
    facebook_mock_auth_hash(info: { email: user.email })
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end

  scenario 'sign user with authorization' do
    user.authorizations.create(provider: 'facebook', uid: '123456')
    visit new_user_registration_path
    facebook_mock_auth_hash(info: { email: user.email })
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end

  it 'handle authentication error' do
    facebook_mock_invalid_auth_hash
    visit new_user_registration_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
  end
end
