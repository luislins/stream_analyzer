class TwitchStreamer < ApplicationRecord
  has_many :viewer_snapshots, as: :streamable
  
  validates :username, presence: true, uniqueness: true
  validates :twitch_id, presence: true, uniqueness: true

  scope :live, -> { where(live: true) }
  scope :offline, -> { where(live: false) }
  scope :by_followers, -> { order(followers: :desc) }
  scope :by_viewers, -> { order(viewers: :desc) }

  def average_viewers
    # TODO: Implementar cálculo de média de viewers
    0
  end

  def stream_duration
    return nil unless live && last_stream_at
    Time.current - last_stream_at
  end

  def formatted_stream_duration
    return nil unless stream_duration
    hours = (stream_duration / 1.hour).floor
    minutes = ((stream_duration % 1.hour) / 1.minute).floor
    "#{hours}h #{minutes}m"
  end

  def growth_rate
    # TODO: Implementar cálculo de taxa de crescimento
    0
  end
end
