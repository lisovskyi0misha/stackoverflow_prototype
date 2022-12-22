class QuestionChannel < ApplicationCable::Channel
  def subscribed
    channel = params[:room]
    stream_from channel
  end
end
