class ImagesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PUT /images.json
  def update_many
    image_errors = []
    image_ids = params.require(:image)[:ids]
    image_positions = params.require(:image)[:positions]
    image_ids.each_with_index do |id, index|
      image = Image.find(id)
      unless image.update(id: id, position: image_positions[index])
        image_errors << image.errors
      end
    end
    respond_to do |format|
      unless image_errors.count > 0
        format.json { render :index, status: :ok, location: images_path }
      else
        format.json { render json: image_errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:title, :imageable_id, :imageable_type, :item, :position)
    end
end
