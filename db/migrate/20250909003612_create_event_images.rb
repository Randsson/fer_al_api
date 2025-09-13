class CreateEventImages < ActiveRecord::Migration[8.0]
  def change
    create_table :event_images do |t|
      t.string :url
      t.string :caption
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
