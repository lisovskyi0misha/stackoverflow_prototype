require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  Users can delete only their own answers
  } do
  given(:user_with_answer) { create(:user) }
  given(:user_without_answer) { create(:user) }
  given(:question) { create(:question,  user_id: user_with_answer.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: question.user_id) }
  scenario 'Authenticated user tries to delete his own answer' do
    authorize(user_with_answer)
    answer
    visit question_path(id: question.id)
    click_on 'Delete answer'
    within('#answers') do
      expect(page).to_not have_content(answer.body)
    end
  end

  scenario 'Authenticated user tries to delete other person`s answer' do
    authorize(user_without_answer)
    answer
    visit question_path(id: question.id)
    expect(page).to_not have_content('Delete answer')
  end

  scenario 'Non-authenticated user tries to delete answer' do
    answer
    visit question_path(id: question.id)
    expect(page).to_not have_content('Delete answer')
  end
end
