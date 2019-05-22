class AddCurrentChargeToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :current_charge, :decimal
  end
end
