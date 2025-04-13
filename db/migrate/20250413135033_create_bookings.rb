class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :player, null: false, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.integer :total_price
      t.integer :status
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
