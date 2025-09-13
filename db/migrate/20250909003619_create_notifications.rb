class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.text :message, null: false
      t.integer :notification_type, null: false
      t.boolean :read, default: false
      t.references :user, null: false, foreign_key: true
      t.references :event, null: true, foreign_key: true

      t.timestamps
    end

    add_index :notifications, :read
    add_index :notifications, :notification_type
  end
end
