require File.expand_path("/home/ty/CandyFinder/config/environment")
require 'ruby-prof'

#RubyProf.measure_mode = RubyProf::WALL_TIME
#RubyProf.start

beginning = Time.now

require 'mechanize'

agent = Mechanize.new
response = agent.get("https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyB7Px85Mowk_a-S05aVqfvnzsDX98qLjYA&reference=CoQBdAAAAFp5PAbWJm38PNjr4TuMrx1cAFujG237HBh-x7qKsKfHd0DTrQKSlVa2GgxZuXjAZZJYTcVk1_D7KW_PVbwa_9Bi1S8FZXTo_qss98rWdFc5hBJHZ9aMV4L5JxP__wLnHDxTzzKuK_vuNz61i9iSMPTD1KP3TecfzxY9y-lslDfPEhB9W7Rx_xMJXb44YsstCEDrGhT7brR5bFlLTfP2m0KzldYle6HshA&sensor=false")
#puts response.body

json = JSON.parse(response.body)
json = json['result']

full_address = json['formatted_address']
phone_formatted = json['formatted_phone_number']
phone_intl = json['international_phone_number']
id = json['id']
name = json['name']
reference = json['reference']
url = json['url']
location = json['geometry']['location']
lat = location['lat']
lon = location['lng']

address_components = full_address.split(', ')
address = address_components[0]
city = address_components[1]
state_zip = address_components[2].split(' ')
state = state_zip[0]
zip = state_zip[1]
country = address_components[3]

l = Location.new
l.name = name
l.lat = lat
l.lon = lon
l.ext_url = url
l.ext_reference = reference
l.phone_international = phone_intl
l.phone_formatted = phone_formatted
l.address = address
l.city = city
l.state = state
l.zip = zip
l.ext_id = id

if l.valid?
  puts "it's valid"
end

puts "Time elapsed: #{Time.now - beginning} seconds"

#puts RubyProf.measure_process_time

#result = RubyProf.stop
#printer = RubyProf::GraphPrinter.new(result)
#printer = RubyProf::FlatPrinter.new(result)
#printer.print(STDOUT, 0)
#puts RubyProf.measure_wall_time
#puts RubyProf.measure_process_time
