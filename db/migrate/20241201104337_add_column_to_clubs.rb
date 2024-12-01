class AddColumnToClubs < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :stadium, :string
    add_column :clubs, :photo, :string
  end
end
