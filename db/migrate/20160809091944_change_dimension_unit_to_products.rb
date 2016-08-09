class ChangeDimensionUnitToProducts < ActiveRecord::Migration
  def change
  	change_table :products do |t|
  		t.rename :width_cm, :width_mm
  		t.rename :height_cm, :height_mm
  		t.rename :depth_cm, :depth_mm
  	end
  end
end