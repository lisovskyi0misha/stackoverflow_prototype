require_relative '../acceptance_helper'

feature 'vote for answer', %{
  Authenticated user can vote either if he likes answer or dislike answer
  User can vote only once for each answer
  User can re-vote for answer if he want
  User can`t vote for his own answer`
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }
  given(:answer) { create(:answer, user_id: author.id, question_id: question.id) }

  scenario 'Authenticated user tries to like the answer' do
    authorize(user)
    answer
    visit question_path(question)
    within '#answers' do
      click_on 'Like'
    end
    within '.votes' do
      expect(page).to have_content('Likes: 1')
    end
    expect(page).to have_button('Like', disabled: true)
    expect(page).to have_button('Dislike', disabled: true)
  end

  scenario 'Non-authenticated user tries to like the answer'

  scenario 'Authenticated user tries to vote his own answer'
end