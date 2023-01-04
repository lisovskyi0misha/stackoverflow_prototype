module AcceptanceMacros
  def authorize(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def send_answer
    visit questions_path
    within('.questions') do
      click_on 'Details'
    end
    fill_in 'Your answer', with: 'Some answer body'
    attach_file 'File', "#{Rails.root}/spec/acceptance/answers/edit_answer_spec.rb"
    click_on 'Send answer'
  end

  def test_question_answers(question, answers)
    visit question_path(id: question.id)
    expect(page).to have_content(question.title)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end

  def prepare_for_delete_best(user)
    login_as(user)
    question.best_answer = answer
    question.save
    visit question_path(question)
  end

  def vote_for_question(question, action)
    visit question_path(question)
    within '.question-votes' do
      click_on action
    end
  end

  def question_after_vote_expectations(number, disabled)
    within '.question-votes' do
      expect(page).to have_content(number)
      expect(page).to have_button('Like', disabled: disabled)
      expect(page).to have_button('Dislike', disabled: disabled)
    end
  end

  def search
    visit search_path
    fill_in 'Search', with: 'ransack'
    click_on 'Search'
  end
end
