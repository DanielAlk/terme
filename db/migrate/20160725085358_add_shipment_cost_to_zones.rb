class AddShipmentCostToZones < ActiveRecord::Migration
  def change
    add_column :zones, :shipment_cost, :decimal, precision: 8, scale: 2, default: 0
  end
end
