class CandiesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :index, :show, :new, :edit, :update, :destroy, :approve_pending, :deny_pending ]
  layout "admin"

  def index
    @candies = Candy.all
  end

  def show
	@id = params[:id]
	@candy = Candy.find_by_id(@id)	
  end

  # GET /candies/new
  # GET /candies/new.json
  def new
    @candy = Candy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @candy }
    end
  end

  # GET /candies/1/edit
  def edit
    @candy = Candy.find(params[:id])
  end

  # POST /candies
  # POST /candies.json
  def create
    @candy = PendingCandy.new(params[:candy])

    respond_to do |format|
      if @candy.save
        logger.info "candy saved successfully"
	logger.info @candy.to_json
        format.html { redirect_to @candy, :notice => 'Candy was successfully created.' }
        format.json { render :json => { :status => 200, :candy => @candy } }
      else
        logger.info "error saving candy"
        logger.info @candy.errors.full_messages
        format.html { render :action => "new" }
        format.json { render :json => {:message => @candy.errors.full_messages.join("\n"), :status => 404} }
      end
    end
  end

  # PUT /candies/1
  # PUT /candies/1.json
  def update
    @candy = Candy.find(params[:id])

    respond_to do |format|
      if @candy.update_attributes(params[:candy])
        format.html { redirect_to @candy, :notice => 'Candy was successfully updated.' }
        format.json { render :json => @candy, :status => :updated, :candy => @candy }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @candy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /candies/1
  # DELETE /candies/1.json
  def destroy
    @candy = Candy.find(params[:id])
    @candy.destroy

    respond_to do |format|
      format.html { redirect_to candies_url }
      format.json { head :ok }
    end
  end

  def create_pending
    @candy = PendingCandy.new(params[:candy])
    logger.info @candy.to_json

    respond_to do |format|
      if @candy.save
        logger.info "pending candy saved successfully"
        logger.info @candy.to_json
        format.html { redirect_to @candy, :notice => 'Candy was successfully created.' }
        format.json { render :json => {:status => 200, :candy => @candy } }
      else
        logger.info "error saving pending candy"
        format.html { render :action => "new" }
        format.json { render :json => {:message => @candy.errors.full_messages.join("\n"), :status => 404 } }
      end
    end
  end
  
  def from_location
    locationID = params[:id]

    #Gets candies and sets their "updated_at" attribute to the date the respective annotation was updated
    @c = Candy.candies_from_location_ids(locationID)

    respond_to do |format|
        format.html
        format.json {render :json => @c }
    end
  end

  def name
    name = params[:id]
    @candies =  []
    if name
      @candies = Candy.search_by_name(name)
      logger.info @candies.to_json
    end
    respond_to do |format|
      format.html { render 'search' }
      format.json { render :json => @candies }
    end
  end

  def sku
    sku = params[:id]
    @candy = Candy.find_by_sku(sku)
    unless(@candy.nil?)
      @candy = [@candy]
    end
    logger.info @candy.to_json

    respond_to do |format|
      format.html
      format.json { render :json => @candy }
    end
  end

  def approve_pending
    logger.info "approve_pending"
    p = PendingCandy.find(params[:id])
    p.title = params[:pending_candy][:title]
    p.subtitle = params[:pending_candy][:subtitle]
    c = Candy.candy_from_pending(p)
    if(c.save)
      p.destroy
    else
      logger.info c.errors.full_messages.to_sentence
    end
    #render :nothing => true
    respond_to do |format|
      format.js
    end
  end

  def deny_pending
    logger.info "deny_pending"
    PendingCandy.destroy(params[:id])
    render :nothing => true
  end

  def get_timestamp
    annotation = Annotation.find_by_candy_id_and_location_id(params[:id], params[:location_id])
    if(annotation)
      logger.info annotation.updated_at
      render :text => annotation.updated_at
    else
      render :text => ''
    end
  end

end
