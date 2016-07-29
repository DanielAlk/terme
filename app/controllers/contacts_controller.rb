class ContactsController < ApplicationController
  include Filterize
  before_action :authenticate_admin!, unless: Proc.new { user_signed_in? && action_name.to_sym == :create }
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_kind, only: :index
  before_action :filterize, only: :index
  filterize order: :created_at_desc, param: :f
  layout 'panel'

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @contacts.send(@kind).paginate(:page => params[:page], :per_page => 6)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact.update_attribute(:read, true)
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to after_create_url, notice: 'Gracias por contactarte con ariaweb.com.ar' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def after_create_url
      if params[:after_create_url].present?
        params[:after_create_url]
      else
        @contact
      end
    end

    def set_kind
      @kind = @contact.present? ? @contact.kind.try(:to_sym) : params[:kind].try(:to_sym)
      @kind = :regular unless @kind.present?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:kind, :name, :email, :company, :subject, :message)
    end
end
