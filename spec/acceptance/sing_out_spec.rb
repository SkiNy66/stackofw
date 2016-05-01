require 'rails_helper'

feature 'Sign out', %q{
  In order to exit
  As an user
  I want to be able to sign out
} do
  
  scenario 'Autenticated user sign out'
  scenario 'Non-utenticated user tries to sign out'
end