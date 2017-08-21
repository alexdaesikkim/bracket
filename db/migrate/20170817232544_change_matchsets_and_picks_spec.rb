class ChangeMatchsetsAndPicksSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :matchsets, :name, :string
    add_column :matchsets, :difficulty, :string
    add_column :matchsets, :level, :string
    remove_column :matchsets, :song_name
  end
end
