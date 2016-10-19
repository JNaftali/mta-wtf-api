class Station < Stop
  has_many :tracks, foreign_key: 'parent_station_id'
end
