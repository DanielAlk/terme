class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :score
      t.references :reviewer, polymorphic: true, index: true
      t.references :reviewable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
