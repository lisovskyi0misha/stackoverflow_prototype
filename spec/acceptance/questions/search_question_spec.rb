require_relative '../acceptance_helper'

feature 'search' do
  let!(:question) { create(:just_question, title: 'ransack body') }
  let!(:another_question) { create(:just_question) }

  scenario 'questions search' do
    visit questions_path
    fill_in 'Search', with: 'ransack'
    click_on 'Search'
    expect(page).to have_content(question.title)
    expect(page).to_not have_content(another_question.title)
  end
end
