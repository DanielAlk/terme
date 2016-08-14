class AddDolarToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :dolar, :decimal, precision: 8, scale: 2
  end
end
