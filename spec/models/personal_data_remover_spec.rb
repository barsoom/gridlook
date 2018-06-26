require "rails_helper"

describe PersonalDataRemover, ".call" do
  it "removes events for that email, case-insensitive" do
    event = Event.create!(email: "FoO@ExAmplE.cOm")

    expect(EventsData.total_events).to eq(1)

    PersonalDataRemover.call("foo@EXAMPLE.com")

    expect(EventsData.total_events).to eq(0)
    expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
