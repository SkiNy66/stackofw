require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
  In order to fix illustrates in my question
  As an question's author
  I'd like to be able to remove attach files
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Autor delete file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'body-for-new-answer', with: 'This is the answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'
    
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

      click_on 'Delete file'

      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'Autorized, but not autor tries delete file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'body-for-new-answer', with: 'This is the answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'
    
    expect(page).to have_link 'Delete file'
    
    click_on 'Sign out'
    sign_in(another_user)
    visit question_path(question)
    
    expect(page).to_not have_link 'Delete file'
  end

  scenario 'Non-autorized tries delete file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'body-for-new-answer', with: 'This is the answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'
    
    expect(page).to have_link 'Delete file'
    
    click_on 'Sign out'
    visit question_path(question)
    
    expect(page).to_not have_link 'Delete file'
  end
end