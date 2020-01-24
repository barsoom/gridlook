class RemoveUnusedIndices < ActiveRecord::Migration[6.0]
  def change
    remove_index :events, name: "index_events_on_sendgrid_unique_event_id"
    remove_index :events, name: "index_events_on_name"
  end
end
