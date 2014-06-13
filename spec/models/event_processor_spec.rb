require "rails_helper"

describe EventProcessor, "#call" do
  it "creates an Event record from a Gridhook::Event" do
    gridhook_event = Gridhook::Event.new(event: "sent")
    event = EventProcessor.new.call(gridhook_event)

    expect(event).to be_persisted
    expect(event.name).to eq("sent")
  end
end
