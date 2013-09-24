class HeartbeatsController < ApplicationController
  # GET /heartbeats
  # GET /heartbeats.json
  def index
    @heartbeats = Heartbeat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @heartbeats }
    end
  end

  # GET /heartbeats/1
  # GET /heartbeats/1.json
  def show
    @heartbeat = Heartbeat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @heartbeat }
    end
  end

  # GET /heartbeats/new
  # GET /heartbeats/new.json
  def new
    @heartbeat = Heartbeat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @heartbeat }
    end
  end

  # GET /heartbeats/1/edit
  def edit
    @heartbeat = Heartbeat.find(params[:id])
  end

  # POST /heartbeats
  # POST /heartbeats.json
  def create
    @heartbeat = Heartbeat.new(params[:heartbeat])

    respond_to do |format|
      if @heartbeat.save
        format.html { redirect_to @heartbeat, notice: 'Heartbeat was successfully created.' }
        format.json { render json: @heartbeat, status: :created, location: @heartbeat }
      else
        format.html { render action: "new" }
        format.json { render json: @heartbeat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /heartbeats/1
  # PUT /heartbeats/1.json
  def update
    @heartbeat = Heartbeat.find(params[:id])

    respond_to do |format|
      if @heartbeat.update_attributes(params[:heartbeat])
        format.html { redirect_to @heartbeat, notice: 'Heartbeat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @heartbeat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heartbeats/1
  # DELETE /heartbeats/1.json
  def destroy
    @heartbeat = Heartbeat.find(params[:id])
    @heartbeat.destroy

    respond_to do |format|
      format.html { redirect_to heartbeats_url }
      format.json { head :no_content }
    end
  end
end
