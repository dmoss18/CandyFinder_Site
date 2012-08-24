####
#This parses through our database and finds any locations that don't have any google data (like ext_id and ext_reference)
#It then does a google places search based on the locations lat/lon and a 'name' filter to find places that match
#These places are displayed to the user.
#The user designates whether the places match
#If they match, the script will update the location in our database
#THE SCRIPT CURRENTLY DOESN'T UPDATE THE ADDRESS because some of the google places data is inaccurate (either that or our data is inaccurate)
####

require File.expand_path("/home/ty/CandyFinder/config/environment")
require 'rbconfig'
require 'mechanize'
require 'json'

locations = Location.all
agent = Mechanize.new
locations.each do |location|
  if !location.ext_reference
    #agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent.agent.http.reuse_ssl_sessions = false
    #ca_path = File.expand_path "/etc/ssl/certs/ca-certificates.crt"
    #ca_path = File.expand_path "/etc/ssl/certs/cert.pem"
    #agent.ca_file = ca_path
    #cert_store = OpenSSL::X509::Store.new
    #cert_store.add_file '/etc/ssl/certs/cert.pem'
    #agent.agent.http.cert_store = cert_store


    puts "\n\n*\n**\n***\n****\n***\n**\n*"
    puts "Adding Google Places data to #{location.name} at #{location.address} #{location.city}, #{location.state} #{location.zip}"
    puts "=============================================================================================================================="
    url = Places.search_url_with_filter(location.lat, location.lon, { 'name' => 'Holiday', 'rankby' => 'distance' })
    puts url
    response = agent.get(url)
    body = JSON.parse(response.body)
    results = body['results']
    puts "#{results.length} results\n\n"

    if(results.length > 0)

      #Check to see if the first result's address matches any portion of the current location's address
      if(location.address.include?(results[0]['vicinity'].split(" ")[0]))
        puts results[0]['name']
        puts results[0]['vicinity'] 
        puts "Is this correct? (y/n)"
        decision = gets
        if decision.strip == 'y' || decision.strip == 'Y'
	  puts "You chose yes"
          #agent2 = Mechanize.new
          response = agent.get(Places.get_details_url(results[0]['reference']))
          location.populate_from_location(Location.location_from_places_details(response.body))
	  #location.ext_reference = results[0]['reference']
	  #location.ext_id = results[0]['id']
          if location.valid?
	    puts "Saving #{location.name} at #{location.address} #{location.city}"
            location.save
            next
          end #end if new_loc.valid?
        end #end if decision ==...
      end #end if location.address.include?...

      #1st result isn't it, so we display all the results
      results_arr = []
      results.length.times do |i|
        #if result['name'].include? location.name
  	  results_arr << results[i]
	  puts "#{i+1}: #{results[i]['name']}"
	  puts "   " + results[i]['vicinity'] + "\n\n"
        #end
      end

      puts "Which record should I save? (1 - #{results.length}, 0 = Dont save any of these)"
      decision = gets

      if decision.to_i == 0
        #don't populate
        next
      else
        #populate
	#agent3 = Mechanize.new
        response = agent.get(Places.get_details_url(results[decision.to_i - 1]['reference']))
        location.populate_from_location(Location.location_from_places_details(response.body))
	#location.ext_reference = results[decision.to_i - 1]['reference']
	#location.ext_id = results[decision.to_i - 1]['id']
        
	if location.valid?
          puts "It's valid"
	  location.save
        end #end if location.valid?
      
      end #end if decision.to_i == 0
    end #end if results.length > 0
  end #end if !location.ext_reference
end #end locations.each
