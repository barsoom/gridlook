class AddSendgridUniqueEventIdToEvents < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :events, :sendgrid_unique_event_id, :text, null: true

    Event.find_in_batches(batch_size: 100_000) do |event_batch|
      event_batch.each do |event|
        event.update_column(:sendgrid_unique_event_id, event.unique_args.fetch(:sg_event_id, nil))
      end

      print "*"
    end

    puts
  end
end
