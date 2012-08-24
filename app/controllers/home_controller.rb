class HomeController < ApplicationController
  def home
  end

  def index
  end

  def record_hit
    id = params[:id]
    a = AppHit.new
    a.device_id = id
    respond_to do |format|
      if(a.save)
        @result = "app hit saved successfully"
	logger.info @result
        format.html
        format.json { render :json => "ok" }
      else
        @result = "Error saving app hit"
	logger.info @result
        format.html
        format.json { render :json => "fail" }
      end
    end
  end

end
