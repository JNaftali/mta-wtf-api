# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'zip'
require 'csv'
Zip::File.open_buffer(Net::HTTP.get(URI('http://web.mta.info/developers/data/nyct/subway/google_transit.zip'))) do |zipfile|
  stops_table = CSV.parse(zipfile.read(zipfile.entries.find {|entry| entry.name == "stops.txt"}),{headers: true, header_converters: :symbol})
  stops_table.each do |row|
    if row[:location_type] == "1"
      stop = Station.find_or_create_by(mta_id: row[:stop_id])
    else
      stop = Track.find_or_create_by(mta_id: row[:stop_id])
      stop.station = Station.find_by(mta_id: row[:parent_station]) if row[:parent_station]
    end
    stop.assign_attributes(name: row[:stop_name], lat: row[:stop_lat], lon: row[:stop_lon])
    stop.save
  end

  routes_table = CSV.parse(zipfile.read(zipfile.entries.find {|entry| entry.name == "routes.txt"}),{headers: true, header_converters: :symbol})
  routes_table.each do |row|
    route = Route.find_or_create_by(mta_id: row[:route_id])
    route.assign_attributes(short_name: row[:route_short_name], long_name: row[:route_long_name], desc: row[:route_desc], color: row[:route_color], text_color: row[:route_text_color] )
    route.color = 'FFFFFF' unless route.color.class == String && route.color.length == 6
    route.text_color = '000000' unless route.text_color.class == String && route.text_color.length == 6
    route.save
  end
  puts "Reading trips.txt..."
  trips_table = CSV.parse(zipfile.read(zipfile.entries.find {|entry| entry.name == "trips.txt"}),{headers: true, header_converters: :symbol})
  print " Seeding Trips. Progress: 0%\r"
  trips_table.each_with_index do |row, num|
    $stdout.flush
    print " Seeding Trips. Progress: #{num * 100 / trips_table.length}%\r"
    trip = Trip.find_or_create_by(mta_id: row[:trip_id])
    trip.assign_attributes(direction_id: row[:direction_id].to_i, shape_id: row[:shape_id])
    trip.route = Route.find_by(mta_id: row[:route_id])
    trip.save
  end

  puts "\nReading stop_times.txt..."
  stop_times_table = CSV.parse(zipfile.read(zipfile.entries.find {|entry| entry.name == "stop_times.txt"}),{headers: true, header_converters: :symbol})
  print " Seeding StopTimes. Progress: 0%\r"
  stop_times_table.each_with_index do |row, num|
    $stdout.flush
    print " Seeding StopTimes. Progress: #{num * 100 / stop_times_table.length}%\r"
    stop_time = StopTime.find_or_create_by(trip_id: row[:trip_id], track_id: row[:stop_id])
    stop_time.assign_attributes( arrival_time: row[:arrival_time], departure_time: row[:departure_time], stop_sequence: row[:stop_sequence])
    stop_time.save
  end
end
