class AddDataSheetFileToProducts < ActiveRecord::Migration
  def change
    add_attachment :products, :data_sheet_file
  end
end
