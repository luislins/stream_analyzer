class CreateViewerSnapshots < ActiveRecord::Migration[7.1]
  def change
    create_table :viewer_snapshots do |t|
      t.references :streamable, polymorphic: true, null: false
      t.integer :viewer_count
      t.datetime :captured_at

      t.timestamps
    end
  end
end
