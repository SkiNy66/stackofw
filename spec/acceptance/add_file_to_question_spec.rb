require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Title of Test question'
    fill_in 'Body', with: 'Body of Test question'
    attach_file 'File', "#{Rails.root}/spec/helper_spec.rb"
    click_on 'Create'

    expect(page).to have_content 'helper_spec.rb'
  end
end