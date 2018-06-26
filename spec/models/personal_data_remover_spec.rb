require "rails_helper"

describe PersonalDataRemover, ".call" do
  it "removes events for that email, case-insensitive" do
    event = Event.create!(email: "FoO@ExAmplE.cOm")

    expect(EventsData.total_events).to eq(1)

    result = PersonalDataRemover.call("foo@EXAMPLE.com")

    expect(result).to eq 1

    expect(EventsData.total_events).to eq(0)
    expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
