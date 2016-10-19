class Route < ApplicationRecord
  self.primary_key = 'mta_id'
  has_many :trips
  has_many :stations, -> { distinct }, through: :trips
end
