class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :title
      t.string :ancestry
      t.decimal :shipment_cost, precision: 8, scale: 2, default: 0
      t.timestamps null: false
    end
  end
end
