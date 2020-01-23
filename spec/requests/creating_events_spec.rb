require "rails_helper"

describe "The webhook" do
  include Rack::Test::Methods

  before do
    ENV["HTTP_USER"] = "foobar"
    ENV["HTTP_PASSWORD"] = "secret"
  end

  after do
    ENV["HTTP_USER"] = nil
    ENV["HTTP_PASSWORD"] = nil
  end

  it "creates events with basic auth enabled" do
    expect {
      basic_authorize "foobar", "secret"
      post "/events", { email: "foo@example.com", associated_records: '[ "Item:123" ]' }.to_json
    }.to change(Event, :count).by(1)

    expect(last_response.status).to eq(200)  # Ok
    event = Event.last
    expect(event.email).to eq("foo@example.com")
    expect(event.associated_records).to eq([ "Item:123" ])
  end

  it "does not create events when basic auth fails" do
    expect {
      basic_authorize "foobar", "wrongsecret"
      post "/events", { email: "foo@example.com" }.to_json
    }.not_to change(Event, :count)

    expect(last_response.status).to eq(401)  # Unauthorized
  end
end
