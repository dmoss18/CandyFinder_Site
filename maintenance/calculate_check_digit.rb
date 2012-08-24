require File.expand_path("/home/ty/CandyFinder/config/environment")

require 'csv'

sku = 0
description = 1
title = 2
al = 3
device_id = 0

CSV.foreach("CandyDB.csv") do |row|
  upc = row[sku]
  puts upc

  puts UPC.calculate_check_digit(upc)
end
