class FreelawsController < ApplicationController
  # GET /freelaws
  # GET /freelaws.json
  def index
    @freelaws = Freelaw.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @freelaws }
    end
  end

  # GET /freelaws/1
  # GET /freelaws/1.json
  def show
    @freelaw = Freelaw.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @freelaw }
    end
  end

  # GET /freelaws/new
  # GET /freelaws/new.json
  def new
    @freelaw = Freelaw.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @freelaw }
    end
  end

  # GET /freelaws/1/edit
  def edit
    @freelaw = Freelaw.find(params[:id])
  end

  # POST /freelaws
  # POST /freelaws.json
  def create
    @freelaw = Freelaw.new(params[:freelaw])

    respond_to do |format|
      if @freelaw.save
        format.html { redirect_to @freelaw, notice: 'Freelaw was successfully created.' }
        format.json { render json: @freelaw, status: :created, location: @freelaw }
      else
        format.html { render action: "new" }
        format.json { render json: @freelaw.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /freelaws/1
  # PUT /freelaws/1.json
  def update
    @freelaw = Freelaw.find(params[:id])

    respond_to do |format|
      if @freelaw.update_attributes(params[:freelaw])
        format.html { redirect_to @freelaw, notice: 'Freelaw was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @freelaw.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freelaws/1
  # DELETE /freelaws/1.json
  def destroy
    @freelaw = Freelaw.find(params[:id])
    @freelaw.destroy

    respond_to do |format|
      format.html { redirect_to freelaws_url }
      format.json { head :no_content }
    end
  end
end
