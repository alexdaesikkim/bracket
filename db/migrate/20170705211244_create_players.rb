class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.integer :challonge_player_id
      t.integer :qualifier_score
      t.integer :seed
      t.integer :place
      t.integer :tournament_id

      t.timestamps
    end
  end
end
