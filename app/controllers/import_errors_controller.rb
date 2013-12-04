class ImportErrorsController < ApplicationController
  # GET /import_errors
  # GET /import_errors.json
  def index
    @import_errors = ImportError.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @import_errors }
    end
  end

  # GET /import_errors/1
  # GET /import_errors/1.json
  def show
    @import_error = ImportError.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @import_error }
    end
  end

  # GET /import_errors/new
  # GET /import_errors/new.json
  def new
    @import_error = ImportError.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @import_error }
    end
  end

  # GET /import_errors/1/edit
  def edit
    @import_error = ImportError.find(params[:id])
  end

  # POST /import_errors
  # POST /import_errors.json
  def create
    @import_error = ImportError.new(params[:import_error])

    respond_to do |format|
      if @import_error.save
        format.html { redirect_to @import_error, notice: 'Import error was successfully created.' }
        format.json { render json: @import_error, status: :created, location: @import_error }
      else
        format.html { render action: "new" }
        format.json { render json: @import_error.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /import_errors/1
  # PUT /import_errors/1.json
  def update
    @import_error = ImportError.find(params[:id])

    respond_to do |format|
      if @import_error.update_attributes(params[:import_error])
        format.html { redirect_to @import_error, notice: 'Import error was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @import_error.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_errors/1
  # DELETE /import_errors/1.json
  def destroy
    @import_error = ImportError.find(params[:id])
    @import_error.destroy

    respond_to do |format|
      format.html { redirect_to import_errors_url }
      format.json { head :no_content }
    end
  end
end
