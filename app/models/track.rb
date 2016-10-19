class Track < Stop
  belongs_to :station, foreign_key: 'parent_station_id'
  has_many :stop_times
end
