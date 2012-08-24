require File.expand_path("/home/ty/CandyFinder/config/environment")

require 'csv'

sku = 0
description = 1
title = 2
al = 3
device_id = 0

CSV.foreach("CandyDB.csv") do |row|
  #c = Candy.where("title = ?", row[title]).first_or_initialize(:title => row[title], :description => row[description], :sku => UPC.calculate_check_digit(row[sku]), :alias => row[al], :subtitle => "")
  c = Candy.find_by_description(row[description])
  if(c.nil?)
    c = Candy.new
    c.title = row[title]
    c.subtitle = ""
    c.sku = UPC.calculate_check_digit(row[sku])
    c.alias = row[al]
    c.description = row[description]

    #save candy here so it gets an id
    c.save
    #reload c to refresh attributes
    c.reload
  end

  puts c.title

  4.upto(49) do |i|
    if(row[i] == "" or row[i] == " " or row[i].nil?)
      break
    else
      a = Annotation.find_by_candy_id_and_location_id(c.id, row[i])
      if(a.nil?)
        a = Annotation.new
        a.candy_id = c.id
        a.candy_sku = c.sku
        a.location_id = row[i]
        a.device_id = device_id
        puts a
        #save annotation here
	if(Location.exists?(row[i]))
          a.save
	else
	  puts "Invalid location id: #{row[i]}"
	end
      end
    end
  end
  #break
end
