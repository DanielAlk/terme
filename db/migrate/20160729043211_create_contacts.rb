class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :kind, default: 0
      t.boolean :read, default: 0
      t.string :name
      t.string :email
      t.string :company
      t.string :subject
      t.text :message

      t.timestamps null: false
    end
  end
end
