require_relative '../acceptance_helper'

feature 'search' do
  let!(:user) { create(:user, email: 'ransack@email') }
  let!(:question) { create(:just_question, title: 'ransack test') }
  let!(:answer) { create(:just_answer, body: 'ransack test body') }
  let!(:comment) { create(:answers_comment, body: 'ransack comment test body') }

  scenario 'users search' do
    search
    expect(page).to have_content(user.email)
  end

  scenario 'questions search' do
    search
    expect(page).to have_content(question.title)
  end

  scenario 'answers search' do
    search
    expect(page).to have_content(answer.body)
  end

  scenario 'comments search' do
    search
    expect(page).to have_content(comment.body)
  end
end
