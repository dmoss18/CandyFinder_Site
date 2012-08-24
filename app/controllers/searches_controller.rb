class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.json

  def name
        @sku = params[:sku]
	@name = params[:name]
	@zip = params[:zip]
	if @zip.empty?
	  render 'home/index'
	else
	 agent = Mechanize.new
         response = agent.get(Geocoder.url_from_zip(@zip))
         #puts response.body
         json = JSON.parse(response.body)
         json = json['results']
         geometry = json[0]['geometry']
         location = geometry['location']
         @lat = location['lat']
         @lon = location['lng']
         if @name.empty? and @sku.empty?
          redirect_to :controller=>'map', :action=>'map_by_location', :zip=>@zip, :lat=>@lat, :lon=>@lon
	  logger.info "after redirect sku and name are emtpy"
	 elsif @name.empty? 
          @candy = Candy.find_by_sku(@sku)
          logger.info "candy is nil: #{@candy.nil?}"
          logger.info "From Mobile: #{@sku} From DB: #{@candy}"
         else
	  @candy = Candy.find(:all, :conditions => ["title like ?", "%#{@name}%"], :order => "title ASC, subtitle ASC")
	  logger.info "From Mobile: #{@name} From DB: #{@candy}"
	 end
	 unless @candy.class == [].class || @candy.nil?
	  @candy = [@candy]
	 end
	 logger.info "before respond_to"
         unless @name.empty? and @sku.empty?
         respond_to do |format|
           format.html # name.html.erb
           format.json { render :json => @candy }
         end
	 end
	end
  end

  def index
    @searches = Search.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @search }
    end
  end
  # GET /searches/new
  # GET /searches/new.json
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, :notice => 'Search was successfully created.' }
        format.json { render :json => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new" }
        format.json { render :json => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.json
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to @search, :notice => 'Search was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :ok }
    end
  end
end
