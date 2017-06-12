class CreateLandmark < ActiveRecord::Migration[5.1]
  def change

  	create_table :landmarks do |t|
  		
  		t.references :location, index: true, foreign_key: true, null: false

  		t.references :category, index: true, foreign_key: true, null: false

  	end
  end
end
