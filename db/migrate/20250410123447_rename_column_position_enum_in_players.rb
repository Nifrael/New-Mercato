class RenameColumnPositionEnumInPlayers < ActiveRecord::Migration[8.0]
  def change
    rename_column :players, :position_enum, :position
  end
end
