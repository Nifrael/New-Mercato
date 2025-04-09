class AddStatusToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :status, :integer, default: 2
    add_index :players, :status
  end
end
