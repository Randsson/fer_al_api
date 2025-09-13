class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.integer :user_type, null: false, default: 0
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.text :address
      t.text :avatar

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :user_type
    add_index :users, [:latitude, :longitude]
  end
end
