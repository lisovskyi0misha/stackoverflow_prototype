require_relative '../acceptance_helper'

feature 'subscribe to question', %q{
  Authenticated user can subscribe to question to get emails about its answers
  User can subscribe to question only once
  Non-authenticated user cannot subscribe to questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:just_question) }

  scenario 'Authenticated user tries to subscribe to question for the first time' do
    login_as(user)
    visit question_path(question)
    within '.question' do
      click_on 'Subscribe'
    end
    expect(page).to have_content('You`ve been succesfully subscribes')
  end

  scenario 'Authenticated user tries to subscribe to question for more then the first time' do
    login_as(user)
    visit question_path(question)
    within '.question' do
      expect(page).to have_button('Subscribe', disabled: false)
    end
  end
  scenario 'Non-authenticated user tries to subscribe to question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_button('Subscribe')
    end
  end
end
