class AddJourneyToConsumption < ActiveRecord::Migration[5.1]
  def change
    add_reference :consumptions, :journey, foreign_key: true
  end
end
