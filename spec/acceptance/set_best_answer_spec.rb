require_relative 'acceptance_helper'

feature 'Set Best Answer', %{
  In ordet to set best answer for my question
  As an author of question
  I want to be able to set the best answer
  } do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:answer1) { create(:answer, question: question, user: user) }
    given!(:answer2) { create(:answer, question: question, user: user) }

    scenario 'Non-autenticated user tries to set best answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Mark best answer'
    end

    scenario 'Autenticated user tries to set best answer' do
      sign_in(another_user)
      visit question_path(question)
      expect(page).to_not have_content 'Mark best answer'
    end

    describe 'Author' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to set best answer', js: true do
        within("#answer-#{answer1.id}") do
          click_on 'Mark as best answer'

          expect(page).to have_content 'BEST ANSWER'
        end
      end

      scenario 'tries to set another best answer', js: true do
        within "#answer-#{answer1.id}" do
          click_on 'Mark as best answer'

          expect(page).to have_content 'BEST ANSWER'
        end

        within "#answer-#{answer2.id}" do
          click_on 'Mark as best answer'

          expect(page).to have_content 'BEST ANSWER'
        end

        within "#answer-#{answer1.id}" do
          expect(page).to_not have_content 'BEST ANSWER'
        end
      end

      scenario 'Best answer showing first', js: true do
        within "#answer-#{answer2.id}" do
          click_on 'Mark as best answer'

          expect(page).to have_content 'BEST ANSWER' #### ajax delay
        end

        within '.answers' do
          expect(page.first('div')[:id]).to eq "answer-#{answer2.id}"
        end
      end
    end
  end
