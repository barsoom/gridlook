class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :name
  end
end
