require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  # background do
  #   sign_in(user)
  #   visit new_question_path
  # end

  describe 'Authenticated user' do
    context 'Author of question' do
      scenario 'Can add 1 file to new question', js: true do
        sign_in(user)
        visit new_question_path

        fill_in 'Title', with: 'Title of Test question'
        fill_in 'Body', with: 'Body of Test question'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end

      scenario 'Can add many files to new question', js: true do
        sign_in(user)
        visit new_question_path

        fill_in 'Title', with: 'Title of Test question'
        fill_in 'Body', with: 'Body of Test question'

        # within all('.nasted-fields').first do
        #   attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        # end

        click_on 'add file'

        # within all('.nasted-fields').last do
        #   attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        # end

        fields = all('input[type="file"]')
        fields[0].set("#{Rails.root}/spec/spec_helper.rb")
        fields[1].set("#{Rails.root}/spec/rails_helper.rb")

        click_on 'Create'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    context 'Authenticated but not author of question', js: true do
      scenario 'Try to add file' do
        sign_in(another_user)
        visit question_path(question)

        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Non-authenticated user', js: true do
    scenario 'Try to add file' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
