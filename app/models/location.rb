class Location < ActiveRecord::Base
require 'json'

	has_many :annotation
	validates_presence_of :name, :lat, :lon

  def self.location_from_places_details(body)
    json = JSON.parse(body)
    results = json['result']

    location = self.new

    addr_comps = results['address_components']
    addr1 = addr_comps[0]['long_name']
    addr2 = addr_comps[1]['long_name']
    location.address = addr1 + ' ' + addr2
    location.city = addr_comps[2]['long_name']
    location.state = addr_comps[3]['long_name']
    location.zip = addr_comps[5]['long_name']
    Rails.logger.info "Location details: #{location.address}, #{location.city}, #{location.state}, #{location.zip}"

    #full_address = results['formatted_address']
    #address_components = full_address.split(', ')
    #location.address = address_components[0]
    #location.city = address_components[1]
    #state_zip = address_components[2].split(' ')
    #location.state = state_zip[0]
    #location.zip = state_zip[1]
    #country = address_components[3]
    location.phone_formatted = results['formatted_phone_number']
    location.phone_international = results['international_phone_number']
    location.ext_id = results['id']
    location.name = results['name']
    location.ext_reference = results['reference']
    location.ext_url = results['url']
    loc = results['geometry']['location']
    location.lat = loc['lat']
    location.lon = loc['lng']
    location.ext_image_url = results['icon']

    return location
  end

  def populate_from_location(loc)
    #self.address = loc.address
    #self.city = loc.city
    #self.state = loc.state
    #self.zip = loc.zip
    self.phone_formatted = loc.phone_formatted
    self.phone_international = loc.phone_international
    self.ext_id = loc.ext_id
    self.name = loc.name
    self.ext_reference = loc.ext_reference
    self.ext_url = loc.ext_url
    self.lat = loc.lat
    self.lon = loc.lon
    self.ext_image_url = loc.ext_image_url
    self.local_image_url = loc.local_image_url
  end

  def self.locations_from_candy_ids(candies)
    locs = Annotation.find_all_by_candy_id(candies).map { |x| x.location_id }
    return Location.find(locs)
  end

  def self.locations_from_candy_skus(skus)
    locs = Annotation.find_all_by_candy_sku(skus).map { |x| x.location_id }
    return Location.find(locs)
  end

  def self.test
    return Geocoder.miles_to_km(1)
  end

  def distance_from(lat, lon)
    return Geocoder.distance(lat, lon, self.lat, self.lon)
  end

  def self.nearest_five(lat, lon, locations)
    arr = Array.new
    found_nearby = false
    locations.each do |l|
      #get distance for each and put it in array with id
      d = l.distance_from(lat, lon)
      arr << [d, l.id]
      if(d < 1.5)
	found_nearby = true
      end
    end
    #sort by distance
    #pull top 5 distance id's & return
    arr = arr.sort_by{ |obj| obj[0] }
    return self.find(arr[0..4].map{ |x| x[1] })
  end

  def self.nearest_few(lat, lon, locations)
    arr = Array.new
    found_nearby = false
    locations.each do |l|
      #get distance for each and put it in array with id
      d = l.distance_from(lat, lon)
      arr << [d, l.id]
      if(d < 10)
        found_nearby = true
      end
    end
    #sort by distance
    #pull top 5 distance id's & return
    arr = arr.sort_by{ |obj| obj[0] }[0..4]
    i = arr.count - 1
    while(i >= 0 and arr.count > 0 and found_nearby)
      if(arr[i][0] < 10)
        break
      else
        arr.delete_at(i)
      end
      i = i - 1
    end
    return self.find(arr.map{ |x| x[1] })
  end

end
