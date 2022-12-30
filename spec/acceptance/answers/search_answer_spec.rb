require_relative '../acceptance_helper'

feature 'search' do
  let!(:question) { create(:just_question) }
  let!(:answer) { create(:just_answer, body: 'ransack test body', question: question) }
  let!(:another_answer) { create(:just_answer, question: question) }

  scenario 'answers search' do
    visit question_path(question)
    within '.answer-search' do
      fill_in 'Search for answer', with: 'ransack'
      click_on 'Search'
    end
    expect(page).to have_content(answer.body)
    expect(page).to_not have_content(another_answer.body)
  end
end
