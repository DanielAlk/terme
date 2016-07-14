class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :ancestry
      t.boolean :fixed, default: false
      t.string :slug

      t.timestamps null: false
    end
		add_index :categories, :slug, unique: true
  end
end
