class Consumption < ApplicationRecord
  belongs_to :vehicle
  belongs_to :journey
  # after_commit { UpdateEnergyJob.perform_later(self) }
end
