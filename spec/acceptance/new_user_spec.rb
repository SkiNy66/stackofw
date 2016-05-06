require 'rails_helper'

feature 'Create new user', %q{
  In order to can ask questions and give answers
  An an guest
  I want to be able to register
} do
  
  scenario 'Guest crate new user' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'testreqister@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end