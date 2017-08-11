class CreatePlayermatches < ActiveRecord::Migration[5.0]
  def change
    create_table :playermatches do |t|
      t.integer :player_id
      t.integer :match_id

      t.timestamps
    end
  end
end
