class ChangeIndexesOnEvents < ActiveRecord::Migration
  def change
    add_index :events, [ :mailer_action, :happened_at, :id ]

    remove_index :events, name: "index_events_on_happened_at"
    remove_index :events, name: "index_events_on_mailer_action"
  end
end
