class ChangeClubNameInPlayers < ActiveRecord::Migration[8.0]
  def change
    rename_column :players, :club, :club_name
  end
end
