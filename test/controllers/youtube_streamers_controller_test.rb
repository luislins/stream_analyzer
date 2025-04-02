require "test_helper"

class YoutubeStreamersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get youtube_streamers_index_url
    assert_response :success
  end

  test "should get show" do
    get youtube_streamers_show_url
    assert_response :success
  end
end
