module AcceptanceMacros
  def authorize(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def send_answer
    visit questions_path
    click_on 'Details'
    fill_in 'Answer', with: 'Some answer body'
    click_on 'Send answer'
    save_and_open_page
    expect(page).to have_content('Some answer body')
  end

  def test_question_answers(question, answers)
    visit question_path(id: question.id)
    expect(page).to have_content(question.title)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
