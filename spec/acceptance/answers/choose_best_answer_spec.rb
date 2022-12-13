require_relative '../acceptance_helper'

feature 'choose best answer', %q{
  Author of a question can choose one best answer for his question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given(:second_answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given(:user_without_answer) { create(:user) }

  scenario 'user tries to choose best answer for his own question for the first time', js: true do
    login_as(user)
    answer
    visit question_path(question)
    within '#answers' do
      click_on 'Choose as best'
      expect(page).to_not have_content(answer.body)
    end
    within '#best-answer' do
      expect(page).to have_content(answer.body)
    end
    expect(page).to_not have_content('Choose as best')
  end

  scenario 'user tries to choose best answer for his own question for more than first time', js: true do
    login_as(user)
    answer
    second_answer
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'Choose as best'
    end
    click_on 'Choose as best'
    within '#answers' do
      expect(page).to have_content(answer.body)
      expect(page).to_not have_content(second_answer.body)
      expect(page).to have_content('Choose as best')
    end
    within '#best-answer' do
      expect(page).to have_content(second_answer.body)
    end
  end

  scenario 'user tries to choose best answer for other`s question', js: true do
    login_as(user_without_answer)
    answer
    visit question_path(question)
    within '#answers' do
      expect(page).to_not have_content('Choose as best')
    end
  end

  scenario 'non-authorized user tries to choose best answer', js: true do
    answer
    visit question_path(question)
    within '#answers' do
      expect(page).to_not have_content('Choose as best')
    end
  end
end
