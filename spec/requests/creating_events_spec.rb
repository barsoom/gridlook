require "rails_helper"

describe "The webhook" do
  include Rack::Test::Methods

  it "creates events with basic auth enabled" do
    allow(ENV).to receive(:[]) do |key|
      case key
      when "HTTP_USER"
        "foobar"
      when "HTTP_PASSWORD"
        "secret"
      end
    end

    expect {
      basic_authorize "foobar", "secret"
      post "/events", { email: "foo@example.com" }.to_json
    }.to change(Event, :count).by(1)

    event = Event.last
    expect(event.email).to eq("foo@example.com")
  end
end
