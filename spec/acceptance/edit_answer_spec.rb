require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I'd like to be able to edit my answer
} do
  
  given(:user) { create(:user) }
  #given(:another_user) { create(:user) }
  given!(:question) {create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Un-autenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Autenticated user' do
    scenario 'sees link to edit answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    # scenario 'User not sees link to Edit answer for not hos answer' do
    #   sign_in(another_user)
    #   visit question_path(question)
    # end

    # scenario 'Author sees link to Edit answer for his answer' do
    #   sign_in(user)
    #   visit question_path(question)
    # end
  end
end