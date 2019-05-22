class AddLatLongsToJourney < ActiveRecord::Migration[5.1]
  def change
    add_column :journeys, :originLat, :decimal
    add_column :journeys, :originLon, :decimal
    add_column :journeys, :destinationLat, :decimal
    add_column :journeys, :destinationLon, :decimal

  end
end
