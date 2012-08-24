require File.expand_path("/home/ty/CandyFinder/config/environment")

Candy.find_each(:batch_size => 500) do |candy|
  if(candy.sku.length == 12)
    candy.sku = "0#{candy.sku}"
    candy.save
  else
    puts "#{candy.id} - #{candy.title}"
  end
end
