require_relative '../acceptance_helper'

feature 'vote for question', %{
  Authenticated user can vote either if he likes question or dislike question
  User can vote only once for each question
  User can`t vote for his own question`
}, js: true do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }
  given(:vote) { create(:vote, user_id: author.id, votable_id: question.id, votable_type: 'Question') }

  scenario 'Authenticated user tries to like the question' do
    authorize(user)
    question
    vote_for_question(question, 'Like')
    question_after_vote_expectations('1', true)
  end

  scenario 'Authenticated user tries to dislike the question' do
    authorize(user)
    question
    vote_for_question(question, 'Dislike')
    question_after_vote_expectations('-1', true)
  end

  scenario 'Non-authenticated user tries to like the question' do
    question
    vote
    visit question_path(question)
    expect(page).to have_content('1')
    expect(page).to_not have_button('Like')
    expect(page).to_not have_button('Dislike')
  end

  scenario 'Authenticated user tries to vote for his own question' do
    authorize(author)
    question
    vote
    visit question_path(question)
    within '.question-votes' do
      expect(page).to have_content('1')
      expect(page).to_not have_button('Like')
      expect(page).to_not have_button('Dislike')
    end
  end
end
