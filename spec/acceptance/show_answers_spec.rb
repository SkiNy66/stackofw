require_relative 'acceptance_helper'

feature 'Show answers', %q{
  In order to find solution
  As autenticated or non-autenticated user
  I want to be able to see answers
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
 
  scenario 'Autenticated user see answers' do
    sign_in(user)
    answer

    visit question_path(question)

    expect(page).to have_content answer.body
  end

  scenario 'Non-autenticated user see answers' do
    answer

    visit question_path(question)

    expect(page).to have_content answer.body
  end
end