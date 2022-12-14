require_relative '../acceptance_helper'

feature 'delete best answer', %q{
  Author can delete best answer of his question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given(:user_without_answer) { create(:user) }

  scenario 'Author tries to delete best answer of hiw own question', js: true do
    prepare_for_delete_best(user)
    within '#best-answer' do
      expect(page).to have_content(answer.body)
      click_on 'Remove from best'
    end
    within '#best-answer-partial' do
      expect(page).to_not have_content(answer.body)
    end
    within '#answers' do
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'User tries to delete answer of other`s question', js: true do
    prepare_for_delete_best(user_without_answer)
    within '#best-answer' do
      expect(page).to_not have_content('Remove from best')
    end
  end
end
