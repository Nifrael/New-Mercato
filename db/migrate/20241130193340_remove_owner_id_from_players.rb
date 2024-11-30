class RemoveOwnerIdFromPlayers < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :players, column: :owner_id
    remove_column :players, :owner_id, :integer
  end
end
