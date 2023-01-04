require_relative '../acceptance_helper'

feature 'search' do
  let!(:question) { create(:just_question) }
  let!(:answer) { create(:just_answer, { body: 'ransack test body', question: }) }
  let!(:answers_comment) { create(:answers_comment, commentable: answer, body: 'ransack test body') }
  let!(:another_answers_comment) { create(:answers_comment, commentable: answer) }
  let!(:questions_comment) { create(:questions_comment, commentable: question, body: 'ransack test body') }
  let!(:another_questions_comment) { create(:questions_comment, commentable: question) }

  scenario 'comments search' do
    visit question_path(question)
    within '.comment-search' do
      fill_in 'Search for comment', with: 'ransack'
      click_on 'Search'
    end
    expect(page).to have_content(answers_comment.body)
    expect(page).to have_content(questions_comment.body)
    expect(page).to_not have_content(another_answers_comment.body)
    expect(page).to_not have_content(another_questions_comment.body)
  end
end
