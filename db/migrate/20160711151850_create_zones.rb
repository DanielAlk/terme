class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :title
      t.string :ancestry

      t.timestamps null: false
    end
  end
end
