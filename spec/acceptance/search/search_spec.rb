require 'acceptance_helper'

feature 'Can search', %q{
  In order to find information
  As an user
  I'd like to be able to search
} do
  
  let!(:user) { create(:user, email: 'Serching@test.com') }
  let!(:user_2) { create(:user) }
  let!(:question) { create(:question, title: 'Serching question', user: user) }
  let!(:question_2) { create(:question, user: user) }
  let!(:answer) { create(:answer, body: 'Serching answer', user: user) }
  let!(:answer_2) { create(:answer, user: user) }
  let!(:comment) { create(:comment, body: 'Serching comment', user: user, commentable: question) }
  let!(:comment_2) { create(:comment, user: user, commentable: question) }

  scenario 'User can search questions' do
    visit root_path

    fill_in 'search', with: 'Serching question'
    click_on 'Find'

    expect(page).to have_content('Serching question')
  end

  scenario 'User can search answers' do
    visit root_path

    fill_in 'search', with: 'Serching answer'
    click_on 'Find'

    expect(page).to have_content('Serching answer')
  end

  scenario 'User can search comments' do
    visit root_path

    fill_in 'search', with: 'Serching comment'
    click_on 'Find'

    expect(page).to have_content('Serching comment')
  end

  scenario 'User can search users' do
    visit root_path

    fill_in 'search', with: 'Serching@test.com'
    click_on 'Find'

    expect(page).to have_content('Serching@test.com')
  end

  scenario 'User can search anything' do
    visit root_path

    fill_in 'search', with: 'Serching'
    click_on 'Find'

    expect(page).to have_content('Serching question')
    expect(page).to have_content('Serching answer')
    expect(page).to have_content('Serching comment')
    expect(page).to have_content('Serching@test.com')
  end
end