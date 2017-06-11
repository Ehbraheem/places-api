class CreateCategory < ActiveRecord::Migration[5.1]
  def up
  	create_table :categories do |t|
  		t.string :title, null: false

  		t.references :location, index: true, foreign_key: true, null: false
  	end

  	add_index :categories, :title
  end

  def down
  	drop_table :category
  end
end
