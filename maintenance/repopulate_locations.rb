require File.expand_path("/home/ty/CandyFinder/config/environment")
require 'mechanize'

locations = Location.all
agent = Mechanize.new
locations.each do |location|
  if location.ext_reference
    puts "#{location.name} in #{location.city} has a reference. ext_image_url is #{location.ext_image_url}"
    response = agent.get(Places.get_details_url(location.ext_reference))
    new_loc = Location.location_from_places_details(response.body)
    location.ext_image_url = new_loc.ext_image_url
    if location.valid?
      puts "Location is valid.  ext_image_url is #{location.ext_image_url}"
      location.update_attribute(:ext_image_url, new_loc.ext_image_url)
    end
  end
end
