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

  it "does not create events when basic auth fails" do
    allow(ENV).to receive(:[]) do |key|
      case key
      when "HTTP_USER"
        nil
      when "HTTP_PASSWORD"
        nil
      end
    end

    basic_authorize "foobar", "secret"
    post "/events", { email: "foo@example.com" }.to_json

    expect(Event.count).to eq(0)
  end

end
