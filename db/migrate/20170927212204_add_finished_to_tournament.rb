class AddFinishedToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :finished, :boolean, default: false
    add_column :players, :wins, :integer, default: 0
    add_column :players, :losses, :integer, default: 0
    add_column :players, :set_wins, :integer, default: 0
    add_column :players, :set_losses, :integer, default: 0
  end
end
