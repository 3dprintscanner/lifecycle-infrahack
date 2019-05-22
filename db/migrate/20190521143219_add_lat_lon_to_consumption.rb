class AddLatLonToConsumption < ActiveRecord::Migration[5.1]
  def change
    add_column :consumptions, :lat, :decimal
    add_column :consumptions, :lon, :decimal
  end
end
