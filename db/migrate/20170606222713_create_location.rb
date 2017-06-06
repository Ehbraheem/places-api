class CreateLocation < ActiveRecord::Migration[5.1]
  def change
  	create_table :location do |t|
  		t.string :name, null: false
  		t.references :category, index: true, foreign_key: true, null: false
  		
  		t.timestamps null: false
  	end

  	add_index :location, :name
  end
end
