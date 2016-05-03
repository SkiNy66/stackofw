require 'rails_helper'

feature 'Delete Answer', %q{
  In order to delete my answer
  As an autenticated user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Autenticated user delete his answer' do
    sign_in(user)
    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted successfully.'
  end

  scenario 'Autenticated user tries to delete not his answer' do
    sign_in(second_user)
    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer could not deleted.'
  end
  
  scenario 'Non-autenticated user tries to delete answer' do
    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'You need to sign in'
  end

end