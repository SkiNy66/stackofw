require 'acceptance_helper'

feature 'User can sign in with Twitter', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'sign up new user' do
    visit new_user_registration_path
    twitter_mock_auth_hash
    click_on 'Sign in with Twitter'

    fill_in 'email', with: 'newuser@email.com'
    click_on 'Save email'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  scenario 'add authorization to user' do
    user
    visit new_user_registration_path
    twitter_mock_auth_hash
    click_on 'Sign in with Twitter'

    fill_in 'email', with: user.email
    click_on 'Save email'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  scenario 'sign user with authorization' do
    user.authorizations.create(provider: 'twitter', uid: '123456')
    visit new_user_registration_path
    twitter_mock_auth_hash
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  it 'handle authentication error' do
    twitter_mock_invalid_auth_hash
    visit new_user_registration_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end
end
