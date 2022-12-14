require_relative '../acceptance_helper'

feature 'Create question' do
  given(:user) { create(:user) }
  scenario 'Authenticated user tries to create question' do
    
    authorize(user)

    visit questions_path
    click_on 'Create Question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Create Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
