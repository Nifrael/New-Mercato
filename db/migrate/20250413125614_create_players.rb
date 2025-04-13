class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :nationality
      t.integer :height
      t.string :foot
      t.string :position
      t.integer :age
      t.integer :market_value
      t.integer :price_per_day
      t.string :jersey_number
      t.integer :status
      t.string :photo
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
