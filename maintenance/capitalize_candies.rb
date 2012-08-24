require File.expand_path("/home/ty/CandyFinder/config/environment")

candies = Candy.all

candies.each do |c|
  title = c.title.split(" ")
  i = 0
  while i < title.length
    title[i] = title[i].capitalize
    i += 1
  end
  c.title = title.join(" ")
  puts c.title
  c.save
end
