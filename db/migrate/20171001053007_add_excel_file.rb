class AddExcelFile < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :excel, :string
  end
end
