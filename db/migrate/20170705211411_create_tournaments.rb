class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :challonge_tournament_id
      t.integer :game_id
      t.boolean :main_stage
      t.boolean :qualifier_stage

      t.timestamps
    end
  end
end
