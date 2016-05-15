require_relative 'acceptance_helper'

feature 'Set Best Answer', %{
  In ordet to set best answer for my question
  As an author of question
  I want to be able to set the best answer
  } do

    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given!(:question) {create(:question) }
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'Non-autenticated user tries to set best answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Mark best answer'  
    end

    scenario 'Autenticated user tries to set best answer' do
      sign_in(another_user)
      visit question_path(question)
      expect(page).to_not have_content 'Mark best answer' 
    end

    scenario 'Author user tries to set best answer' do
      sign_in(another_user)
      visit question_path(question)
      click_on 'Mark best answer'

      expect(page).to have_content 'Best answer' 
    end

  end