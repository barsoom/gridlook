class AddAssociatedObjectsToEvents < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :events, :associated_objects, :string, array: true, default: []

    # Need "gin" for array indexes: https://stackoverflow.com/a/4059785/6962
    add_index :events, :associated_objects, using: "gin", algorithm: :concurrently
  end
end
