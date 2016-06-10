require 'acceptance_helper'

feature 'Create comment', %q{
  In order to comment question for community
  As an autenticated user
  I want to be able to comment
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Autenticated user creates comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Add comment'
      fill_in 'body-for-new-comment', with: 'This is the comment'
      click_on 'Create comment'

      expect(current_path).to eq question_path(question)

      expect(page).to have_content 'This is the comment'
    end
  end

  scenario 'Non-autenticated user tries to create comment' do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
    expect(page).to_not have_field 'comment body'
  end

  scenario 'User try to create invalid comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Add comment'
      click_on 'Create comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Render new comment via PrivatePub for all subscribers for this channel', js: true do
    sign_in(user)
    visit question_path(question)

    within_window open_new_window do
      visit question_path(question)
      within '.question' do
        click_on 'Add comment'
        fill_in 'body-for-new-comment', with: 'This is the comment'
        click_on 'Create comment'

        expect(page).to have_content 'This is the comment'
      end
    end

    expect(page).to have_content 'This is the comment'
  end
end
