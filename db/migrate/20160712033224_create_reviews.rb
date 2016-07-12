class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.decimal :score, precision: 6, scale: 5
      t.references :reviewer, polymorphic: true, index: true
      t.references :reviewable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
