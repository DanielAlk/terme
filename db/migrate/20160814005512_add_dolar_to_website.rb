class AddDolarToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :dolar, :decimal, precision: 8, scale: 2
  end
end
