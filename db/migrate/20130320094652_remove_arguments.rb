class RemoveArguments < ActiveRecord::Migration
  def change
    # We already migrated the data.
    remove_column :events, :arguments
  end
end
