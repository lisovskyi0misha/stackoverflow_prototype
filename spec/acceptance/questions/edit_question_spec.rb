require_relative '../acceptance_helper'

feature 'edit question', %q{
  Only author can edit his own question
} do
  given(:author) { create(:user) }
  given(:user_without_question) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }

  scenario 'User tries to edit his own question' do
    authorize(author)
    visit question_path(question)
    within '.question' do
      click_on 'Edit'
    end
    fill_in 'Title', with: 'Edited question title'
    fill_in 'Content', with: 'Edited question content'
    click_on 'Update'
    expect(current_path).to eq(question_path(question))
    within '.question' do
      expect(page).to have_content('Edited question title')
      expect(page).to have_content('Edited question content')
    end
    
  end

  scenario 'User tries to edit other user`s question' do
    authorize(user_without_question)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_content('Edit')
    end
  end

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_content('Edit')
    end
  end
end
