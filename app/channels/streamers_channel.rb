class StreamersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "streamers_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end 