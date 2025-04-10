class RemoveColumnPositionInPlayers < ActiveRecord::Migration[8.0]
  def change
    remove_column :players, :position, :string
  end
end
