require "rails_helper"
require "tasks/remove_events"

describe RemoveEvents, ".run" do
  it "removes data older than six months and updates total events" do
    # No need for the logging output in the test
    allow_any_instance_of(RemoveEvents).to receive(:puts)

    event_older_than_six_month = create_event_at(6.months.ago - 1.second)
    event_newer_than_six_month = create_event_at(6.months.ago + 1.second)
    expect(Event.count).to eq(2)  # Sanity
    expect(EventsData.total_events).to eq(2)  # Sanity

    RemoveEvents.run

    expect { event_older_than_six_month.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(Event.find(event_newer_than_six_month).id).to eq(event_newer_than_six_month.id)
    expect(Event.count).to eq(1)
    expect(EventsData.total_events).to eq(1)
  end

  private

  def create_event_at(time)
    Timecop.freeze(time) do
      Event.create!
    end
  end
end
