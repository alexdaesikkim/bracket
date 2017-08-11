class CreateQualifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :qualifiers do |t|
      t.string :name
      t.integer :number
      t.boolean :tiebreaker

      t.timestamps
    end
  end
end
