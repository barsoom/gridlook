require "rails_helper"

describe EventProcessor, "#call" do
  it "creates an Event record from a Gridhook::Event" do
    gridhook_event = Gridhook::Event.new(event: "sent")
    event = EventProcessor.new.call(gridhook_event)

    expect(event).to be_persisted
    expect(event.name).to eq("sent")

    # Make sure that we increment the number of events when we create an event
    expect(EventsData.total_events).to eq(1)
  end
end
