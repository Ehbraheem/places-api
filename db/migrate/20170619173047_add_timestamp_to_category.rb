class AddTimestampToCategory < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :categories, null: false
  end
end
