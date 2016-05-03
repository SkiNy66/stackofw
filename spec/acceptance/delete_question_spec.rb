require 'rails_helper'

feature 'Delete question', %q{
  In order to delete my own question
  As an autenticated user
  I want to be able to delete my question
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Autenticated user delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'Autenticated user tries to delete not his question' do
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in'
  end

  scenario 'Non-autenticated user tries to delete any question' do
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in'
  end

end