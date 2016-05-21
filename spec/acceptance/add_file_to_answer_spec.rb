require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks answer', js: true do
    fill_in 'body-for-new-answer', with: 'This is the answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'
    
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds many files when asks answer', js: true do
    fill_in 'body-for-new-answer', with: 'This is the answer'
    # attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    # attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/spec/rails_helper.rb")
    
    click_on 'Create answer'
    
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end