class CreatePaymentProducts < ActiveRecord::Migration
  def change
    create_table :payment_products do |t|
      t.references :payment, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
