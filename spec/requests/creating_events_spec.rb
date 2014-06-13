require "rails_helper"

describe "The webhook" do
  it "creates events" do
    expect {
      post "/events", email: "foo@example.com"
    }.to change(Event, :count).by(1)

    event = Event.last
    expect(event.email).to eq("foo@example.com")
  end
end
