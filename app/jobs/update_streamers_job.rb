class UpdateStreamersJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting UpdateStreamersJob at #{Time.current}"
    
    TwitchStreamer.find_each do |streamer|
      Rails.logger.info "Updating streamer: #{streamer.username}"
      
      begin
        data = TwitchApiService.new.fetch_streamer_data(streamer.username)
        puts data
        if data
          streamer.update!(
            username: data[:username],
            twitch_id: data[:twitch_id], 
            profile_image_url: data[:profile_image_url],
            live: data[:live],
            viewers: data[:viewers],
            followers: data[:followers],
            current_game: data[:current_game],
            last_stream_at: data[:last_stream_at]
          )
          
          # Create viewer snapshot after successful update
          streamer.viewer_snapshots.create!(
            viewer_count: data[:viewers],
            captured_at: Time.current
          )
          
          Rails.logger.info "Successfully updated streamer: #{streamer.username}"
          
          # Broadcast update via Turbo Streams
          Rails.logger.info "Broadcasting update for streamer_#{streamer.id}"
          Turbo::StreamsChannel.broadcast_replace_to(
            "streamers",
            target: "streamer_#{streamer.id}",
            partial: "twitch_streamers/streamer",
            locals: { streamer: streamer }
          )
          Rails.logger.info "Broadcast completed for streamer_#{streamer.id}"
        else
          Rails.logger.warn "No data returned for streamer: #{streamer.username}"
        end
      rescue => e
        Rails.logger.error "Error updating streamer #{streamer.username}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
    
    # Broadcast timestamp update
    Turbo::StreamsChannel.broadcast_replace_to(
      "streamers",
      target: "last_update_timestamp",
      partial: "twitch_streamers/timestamp"
    )
    
    Rails.logger.info "Completed UpdateStreamersJob at #{Time.current}"
  end
end 