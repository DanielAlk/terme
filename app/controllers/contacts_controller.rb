class ContactsController < ApplicationController
  include Filterize
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: :create, unless: Proc.new {
    user_signed_in? && (action_name.to_sym == :new || action_name.to_sym == :destroy && @contact.newsletter_or_partners?)
  }
  before_action :set_contacts, only: [:update_many, :destroy_many]
  before_action :set_kind, only: [:index, :show, :destroy]
  before_action :filterize, only: :index
  filterize order: :created_at_desc, param: :f
  layout 'panel'

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @contacts.send(@kind).paginate(:page => params[:page], :per_page => 12)
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
        Notifier.notify_admin(@contact).deliver_later
        format.html { redirect_to after_create_url, notice: after_create_notice }
        format.json { render :show, status: :created, location: @contact }
      elsif @contact.newsletter? || @contact.partners?
        format.html { redirect_to after_create_url, alert: @contact.errors[:email][0] }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
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
      format.html { redirect_to after_destroy_url, notice: 'Se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /contacts
  # PATCH/PUT /contacts.json
  def update_many
    respond_to do |format|
      if @contacts.update_all(contact_params)
        format.html { redirect_to contacts_url, notice: 'Contacts were successfully updated.' }
        format.json { render :index, status: :ok, location: contacts_url }
      else
        format.html { render :index }
        format.json { render json: @contacts.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts.json
  def destroy_many
    respond_to do |format|
      if (@contacts.destroy_all rescue false)
        format.html { redirect_to after_destroy_url, notice: 'Contacts were successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to contacts_url, alert: 'Algunos contactos no se puedieron borrar.' }
        format.json { render json: @contacts.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def after_destroy_url
      if params[:after_destroy_url].present?
        params[:after_destroy_url]
      elsif user_signed_in? && [:newsletter, :partners].include?(@kind)
        profile_url
      else
        contacts_url
      end
    end

    def after_create_url
      if params[:after_create_url].present?
        params[:after_create_url]
      else
        @contact
      end
    end

    def after_create_notice
      if params[:after_create_notice].present?
        params[:after_create_notice]
      else
        'Gracias por contactarte con terme.com.ar'
      end
    end

    def set_kind
      @kind = @contact.present? ? @contact.kind.try(:to_sym) : params[:kind].try(:to_sym)
      @kind = :regular unless @kind.present?
    end
    
    def set_contacts
      @contacts = Contact.where(id: params[:ids])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:kind, :read, :name, :email, :company, :subject, :message, :contactable_id, :contactable_type)
    end
end
