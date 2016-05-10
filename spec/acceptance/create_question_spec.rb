require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authnticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'authnticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title of Test question'
    fill_in 'Body', with: 'Body of Test question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Title of Test question'
    expect(page).to have_content 'Body of Test question'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end