require 'rails_helper'

feature 'Create answer', %q{
  User can create answer to particular question
  } do
  given(:user1) { create(:user) }
  given(:question) { create(:question, user_id: user1.id) }
  before { question }

  scenario 'Authneticated user tries to create answer', js: true do
    user = create(:user)
    authorize(user)
    send_answer
    within('#answers') do
      expect(page).to have_content('Some answer body')
    end
  end

  scenario 'Non-authneticated user tries to create answer', js: true do
    send_answer
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
