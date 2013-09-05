class ExampointsController < ApplicationController
  # GET /exampoints
  # GET /exampoints.json
  def index
    @exampoints = Exampoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exampoints }
    end
  end

  # GET /exampoints/1
  # GET /exampoints/1.json
  def show
    @exampoint = Exampoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exampoint }
    end
  end

  # GET /exampoints/new
  # GET /exampoints/new.json
  def new
    @exampoint = Exampoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exampoint }
    end
  end

  # GET /exampoints/1/edit
  def edit
    @exampoint = Exampoint.find(params[:id])
  end

  # POST /exampoints
  # POST /exampoints.json
  def create
    @exampoint = Exampoint.new(params[:exampoint])

    respond_to do |format|
      if @exampoint.save
        format.html { redirect_to @exampoint, notice: 'Exampoint was successfully created.' }
        format.json { render json: @exampoint, status: :created, location: @exampoint }
      else
        format.html { render action: "new" }
        format.json { render json: @exampoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exampoints/1
  # PUT /exampoints/1.json
  def update
    @exampoint = Exampoint.find(params[:id])

    respond_to do |format|
      if @exampoint.update_attributes(params[:exampoint])
        format.html { redirect_to @exampoint, notice: 'Exampoint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exampoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exampoints/1
  # DELETE /exampoints/1.json
  def destroy
    @exampoint = Exampoint.find(params[:id])
    @exampoint.destroy

    respond_to do |format|
      format.html { redirect_to exampoints_url }
      format.json { head :no_content }
    end
  end
end
