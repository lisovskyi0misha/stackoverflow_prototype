require_relative '../acceptance_helper'

feature 'subscribe to question', %q{
  Authenticated user can subscribe to question to get emails about its answers
  User can subscribe to question only once
  Non-authenticated user cannot subscribe to questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:just_question) }
  let(:subscription) { Subscription.create(user_id: user.id, question_id: question.id) }

  scenario 'Authenticated user tries to subscribe to question for the first time' do
    login_as(user)
    visit question_path(question)
    within '.question' do
      perform_enqueued_jobs do
        click_on 'Subscribe'
      end
    end
    expect(page).to have_content('You`ve been succesfully subscribes')
    expect(page).to have_link('Unsubscribe')
  end

  scenario 'Authenticated user tries to subscribe to question for more then the first time' do
    login_as(user)
    subscription
    visit question_path(question)
    within '.question' do
      expect(page).to have_link('Unsubscribe')
    end
  end
  scenario 'Non-authenticated user tries to subscribe to question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link('Subscribe')
      expect(page).to_not have_link('Unsubscribe')
    end
  end
end
