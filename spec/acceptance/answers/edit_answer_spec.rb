require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  Only author can edit his own answer
} do
  given(:author) { create(:user) }
  given(:user_without_answer) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: author.id ) }
  
  scenario 'user tries to edit his own answer' do
    authorize(author)
    answer
    visit question_path(question)
    within '#answers' do
      click_on 'Edit answer'
    end
    fill_in 'Answer', with: 'Changed answer body'
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    within '#answers' do
      expect(page).to have_content('Changed answer body')
    end

  end

  scenario 'user tries to edit other`s answer' do
    authorize(user_without_answer)
    answer
    visit question_path(question)
    within '#answers' do
      expect(page).to_not have_content('Edit answer')
    end
  end

  scenario 'non-authenticated user tries to edit answer' do
    answer
    visit question_path(question)
    within '#answers' do
      expect(page).to_not have_content('Edit answer')
    end
  end
end
