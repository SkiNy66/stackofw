require_relative 'acceptance_helper'

feature 'Delete Answer', %q{
  In order to delete my answer
  As an autenticated user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Autenticated user delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    # expect(page).to have_content 'Answer deleted successfully.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Autenticated user tries to delete not his answer' do
    sign_in(second_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
  
  scenario 'Non-autenticated user tries to delete answer' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Delete answer'
  end

end