class AddUserIdentifierToEvents < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :events, :user_identifier, :string, null: true
    add_index :events, :user_identifier, unique: true, algorithm: :concurrently
  end
end
