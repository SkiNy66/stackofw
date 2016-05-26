require_relative 'acceptance_helper'

feature 'Sign out', %q{
  In order to exit
  As an user
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Autenticated user sign out' do
    visit root_path
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
