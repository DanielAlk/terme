class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.references :imageable, polymorphic: true, index: true
      t.attachment :item
      t.integer :position

      t.timestamps null: false
    end
  end
end
