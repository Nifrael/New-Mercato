class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :country
      t.string :league
      t.integer :budget
      t.string :stadium
      t.string :logo

      t.timestamps
    end
  end
end
