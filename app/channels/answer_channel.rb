class AnswerChannel < ApplicationCable::Channel

  def subscribed
    channel = params[:room]
    stream_from channel
  end

  def unsubscribed
  end
end
