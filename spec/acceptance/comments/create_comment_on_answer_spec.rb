require_relative '../acceptance_helper'

feature 'create comment on answer', %q{
  Authenticated user can create comments to answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:answer) { create(:answer, user_id: user.id, question_id: question.id) }

  scenario 'Authenticated user tries to create comment' do
    login_as(user)
    answer
    visit question_path(question)
    within '.answers' do
      click_on 'Comment'
      fill_in 'Comment', with: 'Some comment text'
      click_on 'Send comment'
      expect(page).to have_content('Some comment text')
    end

  end

  context 'Non-authenticated user tries to create comment'

end