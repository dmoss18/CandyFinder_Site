class LocationsController < ApplicationController
  require 'mechanize'
  require 'json'
  require 'open-uri'

  before_filter :authenticate_user!, :only => [ :index, :show, :new, :edit, :create, :update, :destroy,  :google_places_data, :filtered_google_places_data, :populate_google_places_data ]
  #before_filter :instantiate_mechanize
  layout "admin"

  @@agent = nil
  def agent
    @@agent
  end

  def instantiate_mechanize
	if @@agent.nil?
	 #cert_store = OpenSSL::X509::Store.new
	 #cert_store.add_file = 'lib/cacert.pem'
	 logger.level = Logger::DEBUG
	 @@agent = Mechanize.new{|a| a.log = logger}
	 #@@agent.cert_store = cert_store
	 #@@agent.agent.http.reuse_ssl_sessions = false
	 #@@agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	end
  end

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
	logger.info "location saved successfully"
	logger.info @location.to_json
        format.html { redirect_to @location, :notice => 'Location was successfully created.' }
        format.json { render :json => @location }
      else
	logger.info "error saving location"
        format.html { render :action => "new" }
        format.json { render :json => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])
    logger.info params[:location].to_json

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, :notice => 'Location was successfully updated.' }
        format.json { render :json => @location, :status => :updated, :location => @location }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :ok }
    end
  end

  def from_region
    minLat = params[:minLat]
    maxLat = params[:maxLat]
    minLon = params[:minLon]
    maxLon = params[:maxLon]

    @locations = Location.where("lat >= ? and lat <= ? and lon >= ? and lon <= ?", minLat, maxLat, minLon, maxLon)
    logger.info "locations found: #{@locations.count}"
    respond_to do |format|
	format.html 
	format.json { render :json => @locations }
    end
  end

  def from_candy
    candyID = params[:id]
    lat = params[:lat]
    lon = params[:lon]

    @loc = Location.locations_from_candy_ids(candyID)
    if(lat and lon)
      @loc = Location.nearest_few(lat.to_f, lon.to_f, @loc)
    end

    logger.info "found #{@loc.count} locations"

    respond_to do |format|
	logger.info @loc.to_json
	format.html
	format.json { render :json => @loc }
    end
  end

  def from_sku
    sku = params[:id]
    lat = params[:lat]
    lon = params[:lon]

    @locs = Loaction.locations_from_candy_skus(sku)
    if(lat and lon)
      @locs = Location.nearest_few(lat.to_f, lon.to_f, @locs)
    end

    respond_to do |format|
      logger.info @loc.to_json
      format.html
      format.json { render :json => @loc }
    end
  end

  # POST /locations/create_with_annotation
  # POST /locations/create_with_annotation.json
  def create_with_annotation
    @location = Location.find_by_ext_id(params[:location][:ext_id])
    if @location.nil? && params[:location][:id]
      if(Location.exists?(params[:location][:id]))
        @location = Location.find(params[:location][:id])
      end
    end

    if @location.nil?
      @location = Location.new
      agent = Mechanize.new
      response = agent.get(Places.get_details_url(params[:location][:ext_reference]))
      @location = Location.location_from_places_details(response.body)

      if @location.valid?
        logger.info "it's valid"
	@location.save
	@location.reload
      end
    end
 
    #create new annotation with @location.id
    #save annotation
    a = Annotation.find_by_location_id_and_candy_id(@location.id, params[:candy_id])
    if(a.nil?)
      a = Annotation.new
      a.candy_id = params[:candy_id]
      a.candy_sku = params[:candy_sku]
      a.device_id = params[:device_id]
      if @location.id
        a.location_id = @location.id
      end
      if a.valid?
        a.save
      else
        logger.info "Error saving annotation"
        logger.info a.errors.full_messages.to_sentence
      end
    else
      a.updated_at = Time.now
      a.save
    end

    respond_to do |format|
      if not @location.new_record?
        format.html { redirect_to @location, :notice => 'Location was successfully created.' }
        format.json { render :json => @location }
      else
        logger.info "error saving location"
        logger.info @location.errors.full_messages.to_sentence
        format.html { render :action => "new" }
        format.json { render :json => @location.errors, :status => :unprocessable_entity }
      end
    end 
  end

  # GET /locations/from_search/[search_term]
  # GET /locations/from_search/[search_term].json
  def from_search
    name = params[:id]
    lat = params[:lat]
    lon = params[:lon]
    @locations = Location.locations_from_candy_ids(Candy.ids_by_name(name))
    if(lat and lon)
      @locations = Location.nearest_five(lat.to_f, lon.to_f, @locations)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @locations }
    end
  end

  # GET /locations/from_name/[location_name]
  # GET /locaitions/from_name/[location_name].json
  def from_name
    @locations = Location.where("name like ?", "%#{params[:id]}%")    

    lat = params[:lat]
    lon = params[:lon]

    if(lat and lon)
      @locations = Location.nearest_five(lat.to_f, lon.to_f, @locations)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @locations }
    end
  end

  def google_places_data
  end

  def filtered_google_places_data
    #agent = Mechanize.new
    #agent.agent.http.reuse_ssl_sessions = false
    #agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    url = Places.search_url_with_filter(params[:lat], params[:lon], { 'keyword' => params[:filter], 'rankby' => 'distance' })
    logger.info url
    #response = agent.get(url)
    uri = URI.parse(url)
    body = JSON.parse(uri.read)
    #body = JSON.parse(response.body)
    render :json => body['results']
  end

  # POST /locations
  # POST /locations.json
  def populate_google_places_data
    #agent = Mechanize.new
    #agent.agent.http.reuse_ssl_sessions = false
    #agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #response = agent.get(Places.get_details_url(params[:reference]))
    uri = URI.parse(Places.get_details_url(params[:reference]))
    response = JSON.parse(uri.read)
    location = Location.find(params[:id])
    location.populate_from_location(Location.location_from_places_details(response))

    if location.valid?
	logger.info "Saving google info for location #{params[:reference]}"
	#location.save
	render :json => location
    end
  end

end
