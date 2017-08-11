class CreatePlayerqualifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :playerqualifiers do |t|
      t.integer :player_id
      t.integer :qualifier_id

      t.timestamps
    end
  end
end
