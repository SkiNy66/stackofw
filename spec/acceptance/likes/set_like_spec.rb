require 'acceptance_helper'

feature 'Set likes', %q{
  In order to mark question or answer as likable
  As an autenticated user
  I wat to be able to set like
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }

  describe 'As an non-autenticated user' do
    scenario 'Tries to set like to question' do
      visit question_path(question)

      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'Tries to set like to answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end

  describe 'As an autenticated user' do
    describe 'Set like to question' do
      scenario 'Like' do
        sign_in(another_user)
        visit question_path(question)

        within '.question' do
          click_on 'Like'

          expect(page).to have_content '1'
        end
      end

      scenario 'Dislike', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.question' do
          click_on 'Dislike'

          expect(page).to have_content '-1'
        end
      end
    end

    describe 'Set like to answer' do
      scenario 'Like', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          click_on 'Like'

          expect(page).to have_content '1'
        end
      end

      scenario 'Dislike', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          click_on 'Dislike'

          expect(page).to have_content '-1'
        end
      end
    end

    describe 'Tries to set second like to 1 question' do
      scenario 'Like', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.question' do
          click_on 'Like'
          click_on 'Like'

          expect(page).to have_content '1'
        end
      end

      scenario 'Dislike', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.question' do
          click_on 'Dislike'
          click_on 'Dislike'

          expect(page).to have_content '-1'
        end
      end
    end

    describe 'Tries to set second like to 1 answer' do
      scenario 'Like', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          click_on 'Like'
          click_on 'Like'

          expect(page).to have_content '1'
        end
      end

      scenario 'Dislike', js: true do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          click_on 'Dislike'
          click_on 'Dislike'

          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'As an author' do
    scenario 'Tries to set like to his question', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_content '0'
      end
    end

    scenario 'Tries to set like to his answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_content '0'
      end
    end
  end
end
