class CreateTwitchStreamers < ActiveRecord::Migration[7.1]
  def change
    create_table :twitch_streamers do |t|
      t.string :username
      t.string :twitch_id
      t.string :profile_image_url
      t.boolean :live
      t.integer :viewers
      t.integer :followers
      t.string :current_game
      t.datetime :last_stream_at

      t.timestamps
    end
  end
end
