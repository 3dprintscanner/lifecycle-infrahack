class AddCapacityInfoToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :chargerate, :decimal
    add_column :vehicles, :initialcharge, :decimal
    add_column :vehicles, :dischargerate, :decimal
  end
end
