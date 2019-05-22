class Journey < ApplicationRecord
  belongs_to :owner
  belongs_to :vehicle
  has_many :consumptions
  accepts_nested_attributes_for :consumptions, allow_destroy: true

  def start_time
    consumptions.first.time
  end
  
  def end_time
    consumptions.last.time
  end
end
