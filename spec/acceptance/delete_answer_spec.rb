require 'rails_helper'

feature 'Delete Answer', %q{
  In order to delete my answer
  As an autenticated user
  I want to be able to delete my answer
} do

  scenario 'Autenticated user delete his answer'
  scenario 'Autenticated user tries to delete not his answer'
  scenario 'Non-autenticated user tries to delete answer'

end