require "rails_helper"

describe PersonalDataRemover, ".call" do
  it "removes events for that email, case-insensitive" do
    event = Event.create!(email: "FoO@ExAmplE.cOm")
    Event.create!(email: "bar@example.com")

    expect(EventsData.total_events).to eq(2)

    result = PersonalDataRemover.call("foo@EXAMPLE.com")

    expect(result).to eq "Removed 1 event(s)."

    expect(EventsData.total_events).to eq(1)
    expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
