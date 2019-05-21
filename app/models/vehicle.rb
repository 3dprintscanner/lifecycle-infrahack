class Vehicle < ApplicationRecord
  belongs_to :owner
  has_many :consumptions
  has_many :journeys
end
