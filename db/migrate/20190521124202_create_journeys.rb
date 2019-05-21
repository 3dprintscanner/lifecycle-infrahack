class CreateJourneys < ActiveRecord::Migration[5.1]
  def change
    create_table :journeys do |t|
      t.references :owner, foreign_key: true
      t.references :vehicle, foreign_key: true
      t.string :origin
      t.string :destination

      t.timestamps
    end
  end
end
