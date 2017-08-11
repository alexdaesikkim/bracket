class CreatePicks < ActiveRecord::Migration[5.0]
  def change
    create_table :picks do |t|
      t.integer :player_id
      t.string :song_name

      t.timestamps
    end
  end
end
