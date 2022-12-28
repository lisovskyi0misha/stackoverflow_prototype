class QuestionMailer < ApplicationMailer
  def digest_mail(user)
    @questions = Question.for_the_last_day
    @email = user.email
    mail(to: @email, subject: 'Daily question digest')
  end

end
