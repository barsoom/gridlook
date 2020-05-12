class AddUserTypeAndUserIdToEvents < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :events, :user_type, :string, null: true
    add_column :events, :user_id, :integer, null: true
    add_index :events, [ :user_type, :user_id ], algorithm: :concurrently
  end
end
