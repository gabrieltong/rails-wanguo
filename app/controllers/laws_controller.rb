class LawsController < ApplicationController
  authorize_resource
  # GET /laws
  # GET /laws.json
  def index
    @laws = Law.roots
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @laws }
    end
  end

  # GET /laws/1
  # GET /laws/1.json
  def show
    @law = Law.find(params[:id])
    @law.ancestors.each do |law|
      add_breadcrumb law.title,law_path(law)
    end
    add_breadcrumb @law.title
    @laws = @law.children
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @law }
    end
  end

  # GET /laws/new
  # GET /laws/new.json
  def new
    @law = Law.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @law }
    end
  end

  # GET /laws/1/edit
  def edit
    @law = Law.find(params[:id])
  end

  # POST /laws
  # POST /laws.json
  def create
    @law = Law.new(params[:law])

    respond_to do |format|
      if @law.save
        format.html { redirect_to @law, notice: 'Law was successfully created.' }
        format.json { render json: @law, status: :created, location: @law }
      else
        format.html { render action: "new" }
        format.json { render json: @law.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /laws/1
  # PUT /laws/1.json
  def update
    @law = Law.find(params[:id])

    respond_to do |format|
      if @law.update_attributes(params[:law])
        format.html { redirect_to @law, notice: 'Law was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laws/1
  # DELETE /laws/1.json
  def destroy
    @law = Law.find(params[:id])
    @law.destroy

    respond_to do |format|
      format.html { redirect_to laws_url }
      format.json { head :no_content }
    end
  end
  # 在返回集合的api上设置分页的页数和分页大小
  # 结果：设置好 @page 和 @per_page
  def paginate_params
    @page = params[:page] || 1 
    @per_page = params[:per_page] || 20
    @random = params[:random].to_i || 0
  end  
end
