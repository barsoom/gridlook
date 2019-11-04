require "rails_helper"

describe "/api/v1/events" do
  include Rack::Test::Methods

  before do
    # Even if JWT is configured we still use basic auth for the API.
    ENV["JWT_SESSION_TIMEOUT_IN_SECONDS"] = "600"
    ENV["JWT_KEY"] = "test" * 20
    ENV["JWT_AUTH_MISSING_REDIRECT_URL"] = "http://example.com/request_jwt_auth?app=gridlook"
    ENV["JWT_ALGORITHM"] = "HS512"

    ENV["HTTP_USER"] = "foobar"
    ENV["HTTP_PASSWORD"] = "secret"
  end

  after do
    ENV["HTTP_USER"] = nil
    ENV["HTTP_PASSWORD"] = nil
  end

  it "can query events by user type and id" do
    basic_authorize "foobar", "secret"

    post "/events", {
      event: "open",
      user_type: "Customer",
      user_id: 123,
      email: "foo@example.com",
      category: [ "FooMailer", "FooMailer#bar" ],
      other: "value"
    }.to_json

    event = Event.last

    post "/events", { user_type: "Admin", user_id: 123, email: "admin@example.com" }.to_json
    post "/events", { user_type: "Customer", user_id: 456, email: "bar@example.com" }.to_json
    post "/events", { email: "baz@example.com" }.to_json

    get "/api/v1/events", { user_type: "Customer", user_id: 123 }

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq([
      {
        "category" => [ "FooMailer", "FooMailer#bar" ],
        "data" => {},
        "email" => "foo@example.com",
        "happened_at" => JSON.parse(event.happened_at.to_json),
        "id" => event.id,
        "mailer_action" => "FooMailer#bar",
        "name" => "open",
        "sendgrid_unique_event_id" => nil,
        "unique_args" => {
          "other" => "value"
        }
      }
    ])

    get "/api/v1/events"
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({
      "error" => "You have to specify user_type and user_id."
    })
  end

  it "does not let you query events when auth fails" do
    basic_authorize "foobar", "wrongsecret"

    get "/api/v1/events", { user_type: "Customer", user_id: 123 }

    expect(last_response.status).to eq(401)
  end
end
