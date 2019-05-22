class AddImageUrlToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :imageurl, :string
  end
end
