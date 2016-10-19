class Trip < ApplicationRecord
  self.primary_key = 'mta_id'
  belongs_to :route
  has_many :stop_times
  has_many :stations, through: :stop_times
end
