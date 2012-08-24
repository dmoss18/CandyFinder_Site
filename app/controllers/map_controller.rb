class MapController < ApplicationController
  def map
   @lat = params[:lat] || 40.326371
   @lon = params[:lon] || -111.720416
   @zoom = params[:zoom] || 10
   @annotations = Annotation.find_all_by_candy_id(params[:candy_id])
   @candy = Candy.find(params[:candy_id])
   @locations = Array.new
   @annotations.each do |a|
     @locations << Location.find(a.location_id)
   end
  end

  def map_by_location
   @lat = params[:lat] || 40.326371
   @lon = params[:lon] || -111.720416 
   @zip = params[:zip]
   @zoom = params[:zoom] || 10
   @locations = Location.find_all_by_zip(@zip)
   render 'map'
  end

end
