class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.text :address, null: false
      t.integer :status, null: false, default: 0
      t.boolean :featured, default: false
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :events, :status
    add_index :events, :featured
    add_index :events, :start_date
    add_index :events, :end_date
    add_index :events, [:latitude, :longitude]
  end
end
