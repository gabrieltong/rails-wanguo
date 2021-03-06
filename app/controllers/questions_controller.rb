# encoding: utf-8
class QuestionsController < ApplicationController
  before_filter :authorize,:get_epmenu
  authorize_resource
  # GET /questions
  # GET /questions.json
  def index
    if @epmenu
      @relation = @epmenu.questions
    else
      @relation = Question.where(true)
    end

    if params['kind'] == 'zhenti'
      @title = '历年真题'
      @relation = @relation.scope_zhenti
    end

    if params['kind'] == 'moni'
      @title = '模拟题'
      @relation = @relation.scope_moni
    end
    
    if params['epmenu']
      @relation = @relation.scope_moni.where(:epmenu=>params['epmenu'])
    end

    paginate

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  def paginate_params
    @page = params[:page] || 1 
    @per_page = params[:per_page] || 20
    @random = params[:random].to_i || 0
  end  

  def get_epmenu
    @epmenu = Epmenu.find_by_id(params[:epmenu_id])
  end
end
