# app/services/twitch_api_service.rb
require 'net/http'
require 'uri'
require 'json'

class TwitchApiService
  TWITCH_CLIENT_ID = ENV['TWITCH_CLIENT_ID']
  TWITCH_CLIENT_SECRET = ENV['TWITCH_CLIENT_SECRET']
  TOKEN_URL = 'https://id.twitch.tv/oauth2/token'
  BASE_URL = 'https://api.twitch.tv/helix'

  def initialize
    @access_token = fetch_access_token
  end

  def fetch_streamer_data(username)
    user = get_user(username)
    return unless user

    stream = get_stream(user["id"])
    followers = get_followers_count(user["id"])

    {
      username: user["display_name"],
      twitch_id: user["id"],
      profile_image_url: user["profile_image_url"],
      live: stream.present?,
      viewers: stream ? stream["viewer_count"] : 0,
      current_game: stream ? get_game_name(stream["game_id"]) : nil,
      followers: followers,
      last_stream_at: stream ? stream["started_at"] : nil
    }
  end

  private

  def fetch_access_token
    uri = URI(TOKEN_URL)
    response = Net::HTTP.post_form(uri, {
      client_id: TWITCH_CLIENT_ID,
      client_secret: TWITCH_CLIENT_SECRET,
      grant_type: 'client_credentials'
    })
    JSON.parse(response.body)["access_token"]
  end

  def headers
    {
      'Client-ID' => TWITCH_CLIENT_ID,
      'Authorization' => "Bearer #{@access_token}"
    }
  end

  def get_user(username)
    uri = URI("#{BASE_URL}/users?login=#{username}")
    res = Net::HTTP.get_response(uri, headers)
    JSON.parse(res.body)["data"]&.first
  end

  def get_stream(user_id)
    uri = URI("#{BASE_URL}/streams?user_id=#{user_id}")
    res = Net::HTTP.get_response(uri, headers)
    JSON.parse(res.body)["data"]&.first
  end

  def get_followers_count(user_id)
    uri = URI("#{BASE_URL}/users/follows?to_id=#{user_id}")
    res = Net::HTTP.get_response(uri, headers)
    JSON.parse(res.body)["total"]
  end

  def get_game_name(game_id)
    return nil unless game_id
    uri = URI("#{BASE_URL}/games?id=#{game_id}")
    res = Net::HTTP.get_response(uri, headers)
    JSON.parse(res.body)["data"]&.first&.dig("name")
  end
end
