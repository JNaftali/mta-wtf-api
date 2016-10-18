class Stop < ApplicationRecord
  belongs_to :parent_station, optional: true, class_name: 'Stop'
  has_many :child_stops, class_name: 'Stop', foreign_key: 'parent_station_id'
  has_many :stop_times
end
