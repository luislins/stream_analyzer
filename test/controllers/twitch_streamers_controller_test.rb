require "test_helper"

class TwitchStreamersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get twitch_streamers_index_url
    assert_response :success
  end

  test "should get show" do
    get twitch_streamers_show_url
    assert_response :success
  end
end
