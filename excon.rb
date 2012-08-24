require File.expand_path("/home/ty/CandyFinder/config/environment")
require 'excon'

connection = Excon.new('https://maps.googleapis.com')
response = connection.request(:method => :get, :path => 'https://maps.googleapis.com/maps/api/place/details/json', :query => {:key => 'key=AIzaSyB7Px85Mowk_a-S05aVqfvnzsDX98qLjYA', :reference => 'CoQBdAAAAFp5PAbWJm38PNjr4TuMrx1cAFujG237HBh-x7qKsKfHd0DTrQKSlVa2GgxZuXjAZZJYTcVk1_D7KW_PVbwa_9Bi1S8FZXTo_qss98rWdFc5hBJHZ9aMV4L5JxP__wLnHDxTzzKuK_vuNz61i9iSMPTD1KP3TecfzxY9y-lslDfPEhB9W7Rx_xMJXb44YsstCEDrGhT7brR5bFlLTfP2m0KzldYle6HshA', :sensor => 'true' })

puts "response = #{response.body}"
