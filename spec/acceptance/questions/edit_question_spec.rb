require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to edit question
  As an author of question
  I want to be able to edit me question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Un-autenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Autenticated user' do
    scenario 'Try to edit NOT his question' do
      sign_in(another_user)

      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

    scenario 'Edit his question', js: true do
      sign_in(user)

      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'title', with: 'Edited title'
        fill_in 'body', with: 'Edited body'
        click_on 'Update question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
