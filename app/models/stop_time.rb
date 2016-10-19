class StopTime < ApplicationRecord
  self.primary_keys = :trip_id, :track_id
  belongs_to :trip
  belongs_to :track
  has_one :station, through: :track
end
