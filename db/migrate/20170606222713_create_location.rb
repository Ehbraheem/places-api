class CreateLocation < ActiveRecord::Migration[5.1]
  def up
  	create_table :locations do |t|
  		t.string :name, null: false

  		t.timestamps null: false
  	end

  	add_index :locations, :name
  end

  def down
  	drop_table :location
  end
end
