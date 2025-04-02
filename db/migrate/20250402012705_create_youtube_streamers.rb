class CreateYoutubeStreamers < ActiveRecord::Migration[7.1]
  def change
    create_table :youtube_streamers do |t|
      t.string :channel_name
      t.string :channel_id
      t.integer :subscribers
      t.boolean :live
      t.integer :viewers
      t.datetime :last_stream_at

      t.timestamps
    end
  end
end
