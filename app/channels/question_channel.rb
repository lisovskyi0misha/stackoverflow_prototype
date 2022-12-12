class QuestionChannel < ApplicationCable::Channel

  def subscribed
    channel = 'question_room'
    stream_from channel
  end

  def unsubscribed
  end
end
