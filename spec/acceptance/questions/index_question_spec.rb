require 'rails_helper'

feature 'Index question' do
  given(:user) { create(:user) }
  given(:questions) { create_list(:several_questions, 5, user_id: user.id)}
  before { questions }
    
  scenario 'Non-authorized user tries to watch list of questions' do
    visit root_path
    click_on 'See all questions'
  

    expect(current_path).to eq(questions_path)
    questions.each { |question| expect(page).to have_content(question.title) }
  end

  scenario 'Authorized user tries to watch list of questions' do
    user = create(:user)
    authorize(user)
    visit root_path
    click_on 'See all questions'

    expect(current_path).to eq(questions_path)
    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
