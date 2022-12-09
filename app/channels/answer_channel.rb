class AnswerChannel < ApplicationCable::Channel

  def subscribed
    channel = 'answer_room'
    stream_from channel
  end

  def unsubscribed
  end
end
