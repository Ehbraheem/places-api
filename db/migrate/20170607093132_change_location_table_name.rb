class ChangeLocationTableName < ActiveRecord::Migration[5.1]
  def change
  	rename_table :location, :locations
  end
end
