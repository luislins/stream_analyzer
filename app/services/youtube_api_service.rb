# app/services/youtube_api_service.rb
require 'net/http'
require 'uri'
require 'json'

class YoutubeApiService
  BASE_URL = 'https://www.googleapis.com/youtube/v3'
  API_KEY = ENV['YOUTUBE_API_KEY']

  def fetch_channel_data(channel_id)
    channel_data = get_channel(channel_id)
    return unless channel_data

    live_video = get_live_stream(channel_id)

    {
      channel_name: channel_data["title"],
      channel_id: channel_id,
      subscribers: channel_data["subscriberCount"].to_i,
      live: live_video.present?,
      viewers: live_video ? live_video["concurrentViewers"].to_i : 0,
      last_stream_at: live_video ? live_video["actualStartTime"] : nil
    }
  end

  private

  def get_channel(channel_id)
    url = URI("#{BASE_URL}/channels?part=snippet,statistics&id=#{channel_id}&key=#{API_KEY}")
    res = Net::HTTP.get_response(url)
    data = JSON.parse(res.body)["items"]&.first
    return unless data

    {
      "title" => data["snippet"]["title"],
      "subscriberCount" => data["statistics"]["subscriberCount"]
    }
  end

  def get_live_stream(channel_id)
    search_url = URI("#{BASE_URL}/search?part=snippet&channelId=#{channel_id}&eventType=live&type=video&key=#{API_KEY}")
    res = Net::HTTP.get_response(search_url)
    item = JSON.parse(res.body)["items"]&.first
    return unless item

    video_id = item["id"]["videoId"]
    video_url = URI("#{BASE_URL}/videos?part=liveStreamingDetails&id=#{video_id}&key=#{API_KEY}")
    res = Net::HTTP.get_response(video_url)
    JSON.parse(res.body)["items"]&.first&.dig("liveStreamingDetails")
  end
end
