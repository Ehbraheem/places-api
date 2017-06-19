class ManyLocationToManyCategory < ActiveRecord::Migration[5.1]
  def change
  	remove_column :categories, :location_id
  end
end
