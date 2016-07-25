class AddBooleansToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :save_address, :boolean, default: false
    add_column :payments, :save_card, :boolean, default: false
  end
end
