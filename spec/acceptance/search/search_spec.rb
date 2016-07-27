# require 'rails_helper'
require 'acceptance_helper'

feature 'Can search', %q{
  In order to find information
  As an user
  I'd like to be able to search
} do
  
  given!(:user) { create(:user, email: 'Serching@test.com') }
  given!(:question) { create(:question, title: 'Serching question title', body: 'Serching question body', user: user) }
  given!(:answer) { create(:answer, body: 'Serching answer', user: user) }
  given!(:comment) { create(:comment, body: 'Serching comment', user: user, commentable: question) }

  before do
    visit root_path
    index
  end

  scenario 'User can search questions', type: :sphinx do
    select 'questions', from: 'search_type'
    fill_in 'Search for:', with: 'Serching question'
    click_on 'Find'

    expect(page).to have_content('Serching question')
  end

  scenario 'User can search answers', type: :sphinx do
    select 'answers', from: 'search_type'
    fill_in 'Search for:', with: 'Serching answer'
    click_on 'Find'

    expect(page).to have_content('Serching answer')
  end

  scenario 'User can search comments', type: :sphinx do
    select 'comments', from: 'search_type'
    fill_in 'Search for:', with: 'Serching comment'
    click_on 'Find'

    expect(page).to have_content('Serching comment')
  end

  scenario 'User can search users', type: :sphinx do
    select 'users', from: 'search_type'
    fill_in 'Search for:', with: 'Serching@test.com'
    click_on 'Find'

    expect(page).to have_content('serching@test.com')
  end

  scenario 'User can search anything', type: :sphinx do
    select 'all', from: 'search_type'
    fill_in 'Search for:', with: 'Serching'
    click_on 'Find'
 
    expect(page).to have_content('Serching question')
    expect(page).to have_content('Serching answer')
    expect(page).to have_content('Serching comment')
    expect(page).to have_content('serching@test.com')
  end
end