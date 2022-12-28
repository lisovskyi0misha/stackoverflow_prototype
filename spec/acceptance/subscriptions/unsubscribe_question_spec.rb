require_relative '../acceptance_helper'

feature 'Unsubscribe question' do
  let(:user) { create(:user) }
  let(:question) { create(:just_question) }
  let(:subscription) { Subscription.create(user_id: user.id, question_id: question.id) }

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
