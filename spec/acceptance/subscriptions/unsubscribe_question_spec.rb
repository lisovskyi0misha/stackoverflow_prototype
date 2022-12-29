require_relative '../acceptance_helper'

feature 'Unsubscribe question' do
  given(:user) { create(:user) }
  given(:question) { create(:just_question) }
  given(:subscription) { create(:subscription, { question:, subscribed_user: user }) }

  scenario 'Subscribed authenticated user tries to unsubscribe from question' do
    login_as(user)
    subscription
    visit question_path(question)
    within '.question' do
      click_on 'Unsubscribe'
    end
    expect(page).to have_content('You`ve been successfully unsubscribed from question')
  end

  scenario 'Non-subscribed authenticated user tries to unsubscribe from question' do
    login_as(user)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_button('Unsubscribe')
    end
  end

  scenario 'Non-authorized user tries to unsubscribe from question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_button('Unsubscribe')
    end
  end
end
