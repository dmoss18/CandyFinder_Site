require File.expand_path("/home/ty/CandyFinder/config/environment")

year = 2012
month = 3
day = 30

d = "03/30/2012"

dates = d.split("/")
today = Time.local(dates[2], dates[0], dates[1], 0, 0, 0)
tomorrow = today + 1.day

puts tomorrow.to_date
puts today.to_date

@date = today
@ten_searches = Search.find_by_sql("select count(*), s.candy_id, c.title, c.subtitle from searches s, candies c  where c.id = s.candy_id and s.created_at <= '#{tomorrow.to_date}' and s.created_at >= '#{today.to_date}' group by candy_id order by count(*) DESC limit 10").collect { |x| [x["count(*)"], x["candy_id"], x["title"], x["subtitle"]] }

puts @ten_searches.length
