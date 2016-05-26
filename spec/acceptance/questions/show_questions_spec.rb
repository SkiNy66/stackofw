require 'acceptance_helper'

feature 'Show questions', %q{
  In order to find question
  As an autenticated or non-autenticated user
  I want to be able to see questions
} do
  given(:user) { create(:user) }

  scenario 'Autenticated user see questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content('All questions here')
  end

  scenario 'Non-autenticated user see questions' do
    visit questions_path

    expect(page).to have_content('All questions here')
  end
end
