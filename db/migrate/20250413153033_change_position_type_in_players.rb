class ChangePositionTypeInPlayers < ActiveRecord::Migration[8.0]
  def change
    change_column :players, :position, :integer, using: 'position::integer'
  end
end
