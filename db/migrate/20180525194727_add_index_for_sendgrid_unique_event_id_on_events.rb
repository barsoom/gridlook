class AddIndexForSendgridUniqueEventIdOnEvents < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :events, :sendgrid_unique_event_id, algorithm: :concurrently
  end
end
