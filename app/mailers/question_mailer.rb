class QuestionMailer < ApplicationMailer
  def digest_mail(user)
    @questions = Question.for_the_last_day
    @email = user.email
    mail(to: @email, subject: 'Daily question digest')
  end

  def update_mail(user, question, answer)
    @question = question
    @email = user.email
    @answer = answer
    mail(to: @email, subject: 'Question update')
  end
end
