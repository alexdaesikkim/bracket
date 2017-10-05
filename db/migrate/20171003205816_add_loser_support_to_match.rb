class AddLoserSupportToMatch < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :round, :integer
    add_column :matches, :bracket, :string
  end
end
