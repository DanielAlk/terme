class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.integer :status, default: 0
      t.string :key_code
      t.string :brand
      t.references :category, index: true, foreign_key: true
      t.integer :stock
      t.decimal :price, precision: 8, scale: 2
      t.integer :currency, default: 0
      t.integer :width_cm
      t.integer :height_cm
      t.integer :depth_cm
      t.string :description
      t.text :characteristics
      t.text :data_sheet
      t.text :information
      t.string :external_link
      t.string :slug

      t.timestamps null: false
    end
    add_index :products, :slug, unique: true
  end
end
