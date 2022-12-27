require_relative '../acceptance_helper'

feature 'vote for answer', %{
  Authenticated user can vote either if he likes answer or dislike answer
  User can vote only once for each answer
  User can`t vote for his own answer`
}, js: true do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }
  given(:answer) { create(:answer, user_id: author.id, question_id: question.id) }
  given(:vote) { create(:vote, user_id: author.id, votable_id: answer.id, votable_type: 'Answer') }

  scenario 'Authenticated user tries to like the answer' do
    authorize(user)
    answer
    visit question_path(question)
    within '#answers' do
      click_on 'Like'
    end
    within '.answer-votes' do
      expect(page).to have_content('1')
      expect(page).to have_button('Like', disabled: true)
      expect(page).to have_button('Dislike', disabled: true)
    end
  end

  scenario 'Authenticated user tries to dislike an answer' do
    authorize(user)
    answer
    visit question_path(question)
    within '#answers' do
      click_on 'Dislike'
    end
    within '.answer-votes' do
      expect(page).to have_content('-1')
      expect(page).to have_button('Like', disabled: true)
      expect(page).to have_button('Dislike', disabled: true)
    end
  end

  scenario 'Non-authenticated user tries to like the answer' do
    answer
    vote
    visit question_path(question)
    within '.answer-votes' do
      expect(page).to have_content('1')
      expect(page).to_not have_button('Like', disabled: true)
      expect(page).to_not have_button('Dislike', disabled: true)
    end
  end

  scenario 'Authenticated user tries to vote his own answer' do
    authorize(author)
    answer
    vote
    visit question_path(question)
    within '.answer-votes' do
      expect(page).to have_content('1')
      expect(page).to_not have_button('Like')
      expect(page).to_not have_button('Dislike')
    end
  end
end
