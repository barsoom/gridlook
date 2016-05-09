require "rails_helper"
require "tasks/remove_events"

describe RemoveEvents, ".call" do
  it "removes data older than the limit and updates total events" do
    # No need for the logging output in the test
    limit = RemoveEvents::LIMIT
    allow_any_instance_of(RemoveEvents).to receive(:puts)

    event_older_than_the_limit = create_event_at(limit - 1.second)
    event_newer_than_the_limit = create_event_at(limit + 1.second)
    expect(Event.count).to eq(2)  # Sanity
    expect(EventsData.total_events).to eq(2)  # Sanity

    RemoveEvents.call

    expect { event_older_than_the_limit.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect { event_newer_than_the_limit.reload }.not_to raise_error
    expect(EventsData.total_events).to eq(1)
  end

  private

  def create_event_at(time)
    Timecop.freeze(time) do
      Event.create!
    end
  end
end
