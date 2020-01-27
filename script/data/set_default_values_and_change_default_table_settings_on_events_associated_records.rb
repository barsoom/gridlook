Event.where(associated_records: nil).in_batches.update_all(associated_records: [])

ActiveRecord::Migration.change_column :events, :associated_records, :string, array: true, null: false, default: []
