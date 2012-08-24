require 'mechanize'

module Geocoder

  Radians_Per_Degree = 0.017453293

  def self.url_from_zip(zip)
    return "http://maps.googleapis.com/maps/api/geocode/json?address=#{zip}&sensor=true"
  end

  def self.url_from_lat_lon(lat, lon)

  end

  def self.location(lat, lon)
    agent = Mechanize.new
    return JSON.parse((agent.get("https://maps.googleapis.com/maps/api/geocode/json?location=#{lat},#{lon}&sensor=true")).body)
  end

  def self.distance(lat1, lon1, lat2, lon2, km=false)
    r = 6371.0 #radius of earth (km)
    d = Math.acos(Math.sin(lat1)*Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1)) * r
    dist = d * Radians_Per_Degree
    unless(km)
      dist = dist * 0.621371192
    end
    return dist
  end

  def self.km_to_miles(km)
    return km * 0.621371192
  end

  def self.miles_to_km(miles)
    return miles * 1.609344
  end

end
