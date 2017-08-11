class CreateMatchsets < ActiveRecord::Migration[5.0]
  def change
    create_table :matchsets do |t|
      t.string :song_name
      t.integer :picked_player_id
      t.integer :player1_score
      t.integer :player2_score
      t.integer :match_id

      t.timestamps
    end
  end
end
