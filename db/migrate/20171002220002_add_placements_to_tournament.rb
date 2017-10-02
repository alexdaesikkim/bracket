class AddPlacementsToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :placements, :integer, array: true, default: []
    add_column :tournaments, :finalized, :boolean, default: false
  end
end
