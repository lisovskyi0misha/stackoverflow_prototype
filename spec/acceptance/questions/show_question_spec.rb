require_relative '../acceptance_helper'

feature 'Show question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:answers) { question.answers }
  before { create_list(:answer, 3, question_id: question.id, user_id: question.user_id) }

  scenario 'Authenticated user tries to see questions and their answers' do
    authorize(user)
    test_question_answers(question, answers)
  end

  scenario 'Non-uthenticated user tries to see questions and their answers' do  
    test_question_answers(question, answers)
  end
end
