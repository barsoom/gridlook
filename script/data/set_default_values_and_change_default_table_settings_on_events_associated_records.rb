puts "Starting setting default values #{Time.now}"
puts

batch_size = 10_000

# This will obviously miss new additions since the migration started, but that should be OK. Setting the column default later should fix them.
min_id = Event.minimum(:id)
max_id = Event.maximum(:id)

# Add one to ensure we don't miss anything.
batch_count = ((max_id - min_id + 1) / batch_size.to_f).ceil + 1

1.upto(batch_count).each do |i|
  from_id = (i - 1) * batch_size + 1
  to_id = from_id + batch_size - 1
  puts "Batch #{i} of #{batch_count}, records #{from_id} – #{to_id}."

  Event.where(id: from_id..to_id).where(associated_records: nil).update_all(associated_records: [])
end

puts
puts "Starting default migration... #{Time.now}"

ActiveRecord::Migration.change_column :events, :associated_records, :string, array: true, null: false, default: []
