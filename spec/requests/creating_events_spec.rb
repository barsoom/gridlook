require "rails_helper"

describe "The webhook" do
  include Rack::Test::Methods

  before do
    allow(ENV).to receive(:[]) do |key|
      case key
      when "HTTP_USER"
        "foobar"
      when "HTTP_PASSWORD"
        "secret"
      end
    end
  end

  it "creates events with basic auth enabled" do
    expect {
      basic_authorize "foobar", "secret"
      post "/events", { email: "foo@example.com" }.to_json
    }.to change(Event, :count).by(1)

    expect(last_response.status).to eq(200)  # Ok
    event = Event.last
    expect(event.email).to eq("foo@example.com")
  end

  it "does not create events when basic auth fails" do
    expect {
      basic_authorize "foobar", "wrongsecret"
      post "/events", { email: "foo@example.com" }.to_json
    }.not_to change(Event, :count)

    expect(last_response.status).to eq(401)  # Unauthorized
  end
end
