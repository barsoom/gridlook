class CreateEventsData < ActiveRecord::Migration
  def change
    create_table :events_data do |t|
      t.integer :total_events
    end

    EventsData.create!(total_events: Event.count)
  end
end
