class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :photo
      t.integer :role
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
