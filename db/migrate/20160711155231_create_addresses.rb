class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.references :addressable, polymorphic: true, index: true
      t.string :email
      t.string :fname
      t.string :lname
      t.string :doc_type
      t.string :doc_number
      t.string :company
      t.string :zip_code
      t.string :city
      t.string :mobile
      t.references :zone, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
