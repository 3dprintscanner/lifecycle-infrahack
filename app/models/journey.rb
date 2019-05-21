class Journey < ApplicationRecord
  belongs_to :owner
  belongs_to :vehicle
  has_many :consumptions
end
