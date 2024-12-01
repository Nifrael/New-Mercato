class AddColumnClubIdToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_reference :players, :club, null: true, foreign_key: true
  end
end
