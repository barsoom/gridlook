require "rails_helper"

describe AttributeMapper, "#to_hash" do
  it "builds up an attribute hash from a Gridhook::Event" do
    gridhook_event = Gridhook::Event.new(
      event: "sent",
      email: "foo@bar.com",
      timestamp: "1322000095",
      category: ["FooMailer#bar", "FooMailer"]
    )

    actual = AttributeMapper.new(gridhook_event).to_hash

    expect(actual[:email]).to eq("foo@bar.com")
    expect(actual[:name]).to eq("sent")
    expect(actual[:happened_at]).to eq(Time.utc(2011,11,22, 22,14,55))
    expect(actual[:mailer_action]).to eq("FooMailer#bar")
    expect(actual[:category]).to eq(["FooMailer#bar", "FooMailer"])
  end

  # http://sendgrid.com/docs/API_Reference/Webhooks/event.html
  it "puts known attributes in data" do
    attributes = {
      :"smtp-id" => "x",
      attempt: "x",
      response: "x",
      url: "x",
      reason: "x",
      type: "x",
      status: "x"
    }

    gridhook_event = Gridhook::Event.new(attributes)
    actual = AttributeMapper.new(gridhook_event).to_hash

    expect(actual[:data]).to eq(attributes)
  end

  # http://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html
  it "considers any additional attributes to be unique arguments" do
    gridhook_event = Gridhook::Event.new(
      email: "foo@bar.com",
      extra: "extra"
    )

    actual = AttributeMapper.new(gridhook_event).to_hash
    expect(actual[:unique_args]).to eq({ extra: "extra" })
  end
end
