require "rails_helper"
require "tasks/remove_events"

describe RemoveEvents, ".run" do
  it "removes data older than six months" do
    # No need for the logging output in the test
    allow_any_instance_of(RemoveEvents).to receive(:puts)

    event = create_event_at(6.months.ago + 1.second)
    event = create_event_at(6.months.ago - 1.second)
    expect(Event.count).to eq(2)  # Sanity

    RemoveEvents.run

    expect(Event.count).to eq(1)
  end

  private

  def create_event_at(time)
    Timecop.freeze(time) do
      Event.create!
    end
  end
end
