class AddAssociatedObjectsToEvents < ActiveRecord::Migration[6.0]
  # This prevents Rails from adding a wrapping transaction (can't have one when we use `algorithm: :concurrently`) but does not prevent PG from effectively wrapping each statement in a transaction, as far as we've been able to tell.
  # So cancelling a too-long-running query or killing those connections isn't supposed to be able to corrupt data.
  disable_ddl_transaction!

  def change
    # To avoid locking or rewriting the whole table, we assign default values to existing records in batches, then make the column NOT NULL and set a default:
    # https://github.com/barsoom/devbook/blob/master/deploy_without_downtime/README.md#database

    add_column :events, :associated_records, :string, array: true, null: true

    batch_size = 25_000

    # This will obviously miss new additions since the migration started, but that should be OK. Setting the column default later should fix them.
    min_id = Event.minimum(:id)
    max_id = Event.maximum(:id)

    # Add one to ensure we don't miss anything.
    batch_count = ((max_id - min_id + 1) / batch_size.to_f).ceil + 1

    1.upto(batch_count).each do |i|
      from_id = (i - 1) * batch_size + 1
      to_id = from_id + batch_size - 1
      puts "Batch #{i} of #{batch_count}, records #{from_id} – #{to_id}."

      Event.where(id: from_id..to_id).update_all(associated_records: [])
    end

    change_column :events, :associated_records, :string, array: true, null: false, default: []

    # Need "gin" for array indexes: https://stackoverflow.com/a/4059785/6962
    add_index :events, :associated_records, using: "gin", algorithm: :concurrently
  end
end
