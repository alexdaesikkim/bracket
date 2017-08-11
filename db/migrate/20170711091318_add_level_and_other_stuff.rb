class AddLevelAndOtherStuff < ActiveRecord::Migration[5.0]
  def change
    add_column :qualifiers, :level, :integer
    add_column :qualifiers, :difficulty, :string
    add_column :games, :min_level, :integer
    add_column :games, :max_level, :integer
  end
end
