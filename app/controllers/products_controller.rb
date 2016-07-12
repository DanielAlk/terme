class ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: [:show, :edit, :destroy]
  before_action :related_objects, only: [:create, :update]
  layout 'panel'

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def related_objects
      set_product if params[:id].present?
      @product = @product || Product.new(product_params)
      # Tags
      if params.require(:product)[:update_tags].present?
        if params.require(:product)[:tags].blank?
          @product.taggings.destroy_all
        else
          product_tag_names = @product.tags.map(&:name)
          param_tags = params[:product][:tags].map { |tag_name| tag_name.titlecase }
          @product.tags.each do |tag|
            @product.taggings.where(tag: tag).first.destroy unless param_tags.include? tag.name
          end
          param_tags.each do |tag_name|
            unless product_tag_names.include? tag_name
              if tag = Tag.find_by(name: tag_name)
                @product.taggings.new(tag: tag)
              else
                @product.tags.new(name: tag_name)
              end
            end
          end
        end
      end
      # Tags END
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :status, :key_code, :brand, :category_id, :stock, :price, :currency, :dimensions, :description, :characteristics, :data_sheet, :information, :external_link, :slug)
    end
end
