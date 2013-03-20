require "spec_helper"

describe EventProcessor, "#call" do
  it "creates an Event record from a Gridhook::Event" do
    gridhook_event = Gridhook::Event.new(event: "sent")
    event = EventProcessor.new.call(gridhook_event)

    event.should be_persisted
    event.name.should == "sent"
  end
end
