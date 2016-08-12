class PaymentsController < ApplicationController
  include Cart
  include MercadoPagoHelper
  before_action :authenticate_user!, except: :notifications, unless: Proc.new { admin_signed_in? && [:index, :show].include?(action_name.to_sym) }
  before_action :set_cart, only: :create
  before_action :authenticate_cart!, only: :create
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  layout 'panel'

  # GET /payments
  # GET /payments.json
  def index
    if admin_signed_in?
      @payments = Payment.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 12)
    else
      @payments = current_user.payments.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 12)
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    raise ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\"") if !admin_signed_in? && @payment.user != current_user
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @payment.address = Address.new(address_params)
    @payment.parse_cart(@cart)

    respond_to do |format|
      if @payment.save
        delete_cart if [:approved, :in_process].include?(@payment.status.to_sym)
        Notifier.notify_admin(@payment).deliver_now
        Notifier.notify_user(@payment).deliver_now
        format.html { redirect_to @payment, notice: mercado_pago_message(@payment) }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /payments/notifications/
  def notifications
    if params[:type] == 'payment'
      @payment = Payment.find_mp(params['data.id'])
    end
    respond_to do |format|
      if @payment.present?
        Notifier.notify_admin(@payment, special: :mercadopago_notification).deliver_now
        Notifier.notify_user(@payment, special: :mercadopago_notification).deliver_now
        format.json { render json: @payment.to_json, status: :ok }
      else
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:user_id, :transaction_amount, :installments, :payment_method_id, :token, :mercadopago_payment, :mercadopago_payment_id, :status, :status_detail, :zone_id, :save_address, :save_card)
    end

    def address_params
      address = params.require(:address).permit(:email, :fname, :doc_type, :doc_number, :lname, :company, :address, :zip_code, :city, :zone_id, :mobile)
      address[:zone_id] = payment_params[:zone_id]
      address
    end
end
