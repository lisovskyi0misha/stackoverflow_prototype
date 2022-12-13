require_relative '../acceptance_helper'

feature 'Create answer', %q{
  User can create answer to particular question
  Other users can see new answer without page reload
  } do
  given(:user1) { create(:user) }
  given(:question) { create(:question, user_id: user1.id) }
  before { question }

  scenario 'Authneticated user tries to create answer', js: true do
    user = create(:user)
    login_as(user)
    send_answer
    within('#answers') do
      expect(page).to have_content('Some answer body')
      expect(page).to have_link(('edit_answer_spec.rb'))
    end
  end

  scenario 'Non-authneticated user tries to create answer' do
    send_answer
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'multiple users open same question page', js: true do
    Capybara.using_session('user') do
      user = create(:user)
      login_as(user, scope: :user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Your answer', with: 'Some answer body'
      click_on 'Send answer'
      expect(page).to have_content('Some answer body')
    end

    Capybara.using_session('guest') do
      within('#answers') do
        expect(page).to have_content('Some answer body')
      end
    end
  end
end
