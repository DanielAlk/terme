class PaymentsController < ApplicationController
  include Cart
  include MercadoPagoHelper
  before_action :authenticate_user!
  before_action :set_cart, only: :create
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  layout 'panel'

  # GET /payments
  # GET /payments.json
  def index
    @payments = current_user.payments.order(updated_at: :desc)
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    raise ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\"") if @payment.user != current_user
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
        format.html { redirect_to @payment, notice: MercadoPagoMessage(@payment) }
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
      address = params.require(:address).permit(:email, :fname, :lname, :company, :address, :zip_code, :city, :zone_id, :mobile)
      address[:zone_id] = payment_params[:zone_id]
      address
    end
end
