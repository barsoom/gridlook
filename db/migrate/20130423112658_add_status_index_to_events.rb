class AddStatusIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :status
  end
end
