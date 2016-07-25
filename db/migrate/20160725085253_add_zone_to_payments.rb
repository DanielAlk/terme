class AddZoneToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :zone, index: true, foreign_key: true
  end
end
