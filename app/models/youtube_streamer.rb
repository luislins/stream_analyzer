class YoutubeStreamer < ApplicationRecord
  has_many :viewer_snapshots, as: :streamable
end
