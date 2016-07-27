class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :address
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :facebook
      t.string :twitter
      t.string :google
      t.string :linkedin
      t.string :youtube

      t.timestamps null: false
    end
  end
end
