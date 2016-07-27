class CreatePaymentProducts < ActiveRecord::Migration
  def change
    create_table :payment_products do |t|
      t.references :payment, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 8, scale: 2
      t.string :title
      t.string :key_code
      t.string :brand
      t.references :category, index: true, foreign_key: true
      t.integer :currency, default: 0
      t.string :description
      t.string :external_link

      t.timestamps null: false
    end
  end
end
