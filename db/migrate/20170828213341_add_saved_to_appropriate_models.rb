class AddSavedToAppropriateModels < ActiveRecord::Migration[5.0]
  def change
    add_column :matchsets, :saved, :boolean, default: false
  end
end
