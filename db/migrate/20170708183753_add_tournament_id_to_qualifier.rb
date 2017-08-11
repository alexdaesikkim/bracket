class AddTournamentIdToQualifier < ActiveRecord::Migration[5.0]
  def change
    add_column :qualifiers, :tournament_id, :integer
  end
end
