class RemoveNotNullConstraintsFromEventsLatitudeLongitude < ActiveRecord::Migration[8.0]
  def change
    # Remove NOT NULL constraints from latitude and longitude columns
    change_column_null :events, :latitude, true
    change_column_null :events, :longitude, true
  end
end
