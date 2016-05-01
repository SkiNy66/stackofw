require 'rails_helper'

feature 'Create answer', %q{
  In order to give answer for community
  As an autenticated user
  I want to be able to give answer
} do
  
  scenario 'Autenticated user creates answer'
  scenario 'Non-autenticated user tries to create answer'
end