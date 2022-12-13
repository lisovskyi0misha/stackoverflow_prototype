require_relative '../acceptance_helper'

feature 'create comment on question', %q{
  Authenticated user can create comments to questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user tries to create comment', js: true do
    login_as(user)
    visit question_path(question)
    within '.question' do
      click_on 'Comment'
      fill_in 'Comment', with: 'Some comment text'
      click_on 'Send'
      expect(page).to have_content('Some comment text')
    end

  end

  scenario 'Non-authenticated user tries to create comment' do
    visit question_path(question)
    within '.question' do
      click_on 'Comment'
    end
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'Multiple users can see new comment', js: true do
    Capybara.using_session('user') do
      login_as(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within '.question' do
        click_on 'Comment'
        fill_in 'Comment', with: 'Some comment text'
        click_on 'Send'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content('Some comment text')
    end
  end
end
