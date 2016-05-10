require_relative 'acceptance_helper'

feature 'Delete question', %q{
  In order to delete my own question
  As an autenticated user
  I want to be able to delete my question
} do
  
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Autenticated user delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Autenticated user tries to delete not his question' do
    sign_in(second_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-autenticated user tries to delete any question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

end