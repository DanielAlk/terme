class ArticlesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_shape, only: [:index, :new]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  layout 'panel'

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.where(shape: Article.shapes[@shape])
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new(shape: @shape)
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_shape
      @shape = params[:shape].try(:to_sym)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:shape, :status, :title, :subtitle, :description, :text, :link, :image)
    end
end
