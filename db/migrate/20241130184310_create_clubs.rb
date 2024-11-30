class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
