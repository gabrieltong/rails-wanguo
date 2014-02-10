class DlogsController < ApplicationController
  # GET /dlogs
  # GET /dlogs.json
  def index
    @relation = Dlog.order('id desc')
    paginate
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dlogs }
    end
  end

  # GET /dlogs/1
  # GET /dlogs/1.json
  def show
    @dlog = Dlog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dlog }
    end
  end

  # GET /dlogs/new
  # GET /dlogs/new.json
  def new
    @dlog = Dlog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dlog }
    end
  end

  # GET /dlogs/1/edit
  def edit
    @dlog = Dlog.find(params[:id])
  end

  # POST /dlogs
  # POST /dlogs.json
  def create
    @dlog = Dlog.new(params[:dlog])

    respond_to do |format|
      if @dlog.save
        format.html { redirect_to @dlog, notice: 'Dlog was successfully created.' }
        format.json { render json: @dlog, status: :created, location: @dlog }
      else
        format.html { render action: "new" }
        format.json { render json: @dlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dlogs/1
  # PUT /dlogs/1.json
  def update
    @dlog = Dlog.find(params[:id])

    respond_to do |format|
      if @dlog.update_attributes(params[:dlog])
        format.html { redirect_to @dlog, notice: 'Dlog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dlogs/1
  # DELETE /dlogs/1.json
  def destroy
    @dlog = Dlog.find(params[:id])
    @dlog.destroy

    respond_to do |format|
      format.html { redirect_to dlogs_url }
      format.json { head :no_content }
    end
  end
end
