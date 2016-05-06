require 'rails_helper'

feature 'Create answer', %q{
  In order to give answer for community
  As an autenticated user
  I want to be able to give answer
} do
  
  given(:user) { create(:user) }
  given(:question) {create(:question) }

  scenario 'Autenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'This is the answer'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'This is the answer'
    end
  end

  scenario 'Non-autenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Create answer'
    expect(page).to_not have_field 'Body'
  end
end