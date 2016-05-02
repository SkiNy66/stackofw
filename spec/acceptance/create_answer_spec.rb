require 'rails_helper'

feature 'Create answer', %q{
  In order to give answer for community
  As an autenticated user
  I want to be able to give answer
} do
  
  given(:user) { create(:user) }
  given(:question) {create(:question) }

  scenario 'Autenticated user creates answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'
    fill_in 'Body', with: 'This is the answer'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-autenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end