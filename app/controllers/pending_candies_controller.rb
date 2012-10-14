class PendingCandiesController < ApplicationController
  # GET /pending_candies
  # GET /pending_candies.json
  def index
    @pending_candies = PendingCandy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @pending_candies }
    end
  end

  # GET /pending_candies/1
  # GET /pending_candies/1.json
  def show
    @pending_candy = PendingCandy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @pending_candy }
    end
  end

  # GET /pending_candies/new
  # GET /pending_candies/new.json
  def new
    @pending_candy = PendingCandy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @pending_candy }
    end
  end

  # GET /pending_candies/1/edit
  def edit
    @pending_candy = PendingCandy.find(params[:id])
  end

  # POST /pending_candies
  # POST /pending_candies.json
  def create
    @pending_candy = PendingCandy.new(params[:pending_candy])

    respond_to do |format|
      if @pending_candy.save
        format.html { redirect_to @pending_candy, :notice => 'Pending candy was successfully created.' }
        format.json { render :json => @pending_candy, :status => :created, :location => @pending_candy }
      else
        format.html { render :action => "new" }
        format.json { render :json => @pending_candy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pending_candies/1
  # PUT /pending_candies/1.json
  def update
    @pending_candy = PendingCandy.find(params[:id])
    @pending_candy.title = params[:pending_candy][:title]
    @pending_candy.subtitle = params[:pending_candy][:subtitle]
    c = Candy.candy_from_pending(@pending_candy)

    respond_to do |format|
      #if @pending_candy.update_attributes(params[:pending_candy])
      if c.save
        @pending_candy.destroy
	format.js
      else
	c.errors.full_messages.to_sentence
      end
    end
  end

  # DELETE /pending_candies/1
  # DELETE /pending_candies/1.json
  def destroy
    @pending_candy = PendingCandy.find(params[:id])
    @pending_candy.destroy

    respond_to do |format|
      format.html { redirect_to pending_candies_url }
      format.json { head :ok }
      format.js 
    end
  end
end
