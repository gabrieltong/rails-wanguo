class CaptchasController < ApplicationController
  # GET /captchas
  # GET /captchas.json
  def index
    @captchas = Captcha.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @captchas }
    end
  end

  # GET /captchas/1
  # GET /captchas/1.json
  def show
    @captcha = Captcha.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @captcha }
    end
  end

  # GET /captchas/new
  # GET /captchas/new.json
  def new
    @captcha = Captcha.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @captcha }
    end
  end

  # GET /captchas/1/edit
  def edit
    @captcha = Captcha.find(params[:id])
  end

  # POST /captchas
  # POST /captchas.json
  def create
    @captcha = Captcha.new(params[:captcha])

    respond_to do |format|
      if @captcha.save
        format.html { redirect_to @captcha, notice: 'Captcha was successfully created.' }
        format.json { render json: @captcha, status: :created, location: @captcha }
      else
        format.html { render action: "new" }
        format.json { render json: @captcha.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /captchas/1
  # PUT /captchas/1.json
  def update
    @captcha = Captcha.find(params[:id])

    respond_to do |format|
      if @captcha.update_attributes(params[:captcha])
        format.html { redirect_to @captcha, notice: 'Captcha was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @captcha.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /captchas/1
  # DELETE /captchas/1.json
  def destroy
    @captcha = Captcha.find(params[:id])
    @captcha.destroy

    respond_to do |format|
      format.html { redirect_to captchas_url }
      format.json { head :no_content }
    end
  end
end
