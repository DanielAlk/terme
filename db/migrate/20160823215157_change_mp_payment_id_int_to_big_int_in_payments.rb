class ChangeMpPaymentIdIntToBigIntInPayments < ActiveRecord::Migration
  def change
  	change_table :payments do |t|
  		t.change :mercadopago_payment_id, :integer, :limit => 8
  	end
  end
end
