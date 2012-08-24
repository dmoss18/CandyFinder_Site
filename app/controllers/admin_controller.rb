class AdminController < ApplicationController
  before_filter :authenticate

  def index
  end

  def analytics
    @analytics = Analytics.order("created_at DESC").all

    @searches = Search.find_by_sql("select count(*), s.candy_id, c.title, c.subtitle from searches s, candies c  where c.id = s.candy_id group by candy_id order by count(*) DESC").collect { |x| [x["count(*)"], x["candy_id"], x["title"], x["subtitle"]] }
  end

  def candies_pending
    @candies = PendingCandy.all
  end

  def searches
    @searches = Search.find_by_sql("select count(*), s.candy_id, c.title, c.subtitle from searches s, candies c  where c.id = s.candy_id group by candy_id order by count(*) DESC limit 10").collect { |x| [x["count(*)"], x["candy_id"], x["title"], x["subtitle"]] }
  end

  def top_ten_searches
    dates = params[:date].split("/")
    today = Time.local(dates[2], dates[0], dates[1], 0, 0, 0)
    tomorrow = today + 1.day
    logger.info today.to_s

    @date = today
    @ten_searches = Search.find_by_sql("select count(*), s.candy_id, c.title, c.subtitle from searches s, candies c  where c.id = s.candy_id and s.created_at <= '#{tomorrow.to_date}' and s.created_at >= '#{today.to_date}' group by candy_id order by count(*) DESC limit 10").collect { |x| [x["count(*)"], x["candy_id"], x["title"], x["subtitle"]] }
    logger.info @ten_searches.count

    render :layout => false
  end

  protected
    def authenticate
        authenticate_or_request_with_http_basic do |username, password|
          username == 'candyfinderadmin' && password == 'iluvcandy'
        end
    end
end
