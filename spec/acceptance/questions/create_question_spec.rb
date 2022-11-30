require_relative '../acceptance_helper'

feature 'Create question' do
  given(:user) { create(:user) }
  scenario 'Authenticated user tries to create question' do
    
    authorize(user)

    visit questions_path
    click_on 'Create Question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    attach_file 'File', "#{Rails.root}/spec/acceptance/answers/edit_answer_spec.rb"
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created'
    visit question_path(id: Question.first.id)
    expect(page).to have_link('edit_answer_spec.rb')
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Create Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
