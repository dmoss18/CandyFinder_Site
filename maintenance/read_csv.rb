require File.expand_path("/home/ty/CandyFinder/config/environment")

require 'csv'

store = 0
address = 1
city = 2
state = 3
zip = 4
longitude = 5
latitude = 6

CSV.foreach("stores.csv") do |row|
 l = Location.new  
 l.name = row[store]
 l.address = row[address]
 l.city = row[city]
 l.state = row[state]
 l.zip = row[zip]
 l.lon = row[longitude]
 l.lat = row[latitude]
 if l.valid?
  puts "This is Valid"
 else
  puts l.errors.full_messages.to_sentence
 end
 l.save
end
