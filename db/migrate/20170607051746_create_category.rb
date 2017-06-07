class CreateCategory < ActiveRecord::Migration[5.1]
  def up
  	create_table :category do |t|
  		t.title String, null: false

  		t.references :location, index: true, foreign_key: true, null: false
  	end

  	add_index :category, :title
  end

  def down
  	drop_table :category
  end
end
