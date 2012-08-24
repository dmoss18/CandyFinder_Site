require File.expand_path("/home/ty/CandyFinder/config/environment")

#Script to be run every morning
#Gathers analytics data from yesterday's events
#Creates a new row in db [candyfinder_dev].analytics

today = Time.now
yesterday = 1.day.ago
today = Time.local(today.year, today.month, today.day, 0, 0, 0)
yesterday = Time.local(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0)

a = AppHit.where("created_at >= ? and created_at < ?", yesterday, today).map { |x| x.device_id }

analytics = Analytics.new
analytics.total_hits = a.count
unique_hits = a & a
analytics.unique_hits = unique_hits.count

Rails.logger.info "Analytics generated: #{analytics.valid?}"

if(analytics.save)
  Rails.logger.info "Analytics saved successfully on #{Time.now}"
else
  Rails.logger.info "Error saving analytics on #{Time.now}"
end
