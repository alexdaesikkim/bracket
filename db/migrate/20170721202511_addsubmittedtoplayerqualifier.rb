class Addsubmittedtoplayerqualifier < ActiveRecord::Migration[5.0]
  def change
    add_column :playerqualifiers, :submitted, :boolean, default: false
    add_column :playerqualifiers, :score, :integer, default: 0
  end
end
