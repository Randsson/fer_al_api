class CreateUserEventInterests < ActiveRecord::Migration[8.0]
  def change
    create_table :user_event_interests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :interested
      t.boolean :reminded

      t.timestamps
    end
  end
end
