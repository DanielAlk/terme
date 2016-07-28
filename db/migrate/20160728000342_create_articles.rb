class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :shape, default: 0
      t.integer :status, default: 0
      t.string :title
      t.string :subtitle
      t.string :description
      t.text :text
      t.string :link
      t.string :link_title
      t.boolean :link_external, default: 0
      t.attachment :image
      t.integer :position
      t.string :slug

      t.timestamps null: false
    end
    add_index :articles, :slug, unique: true
  end
end
