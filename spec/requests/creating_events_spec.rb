require "spec_helper"

describe "The webhook" do
  it "creates events" do
    expect {
      post "/events", email: "foo@example.com"
    }.to change(Event, :count).by(1)

    event = Event.last
    event.email.should == "foo@example.com"
  end
end
