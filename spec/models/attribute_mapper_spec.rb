require "spec_helper"

describe AttributeMapper, "#to_hash" do
  it "builds up an attribute hash from a Gridhook::Event" do
    gridhook_event = Gridhook::Event.new(
      event: "sent",
      email: "foo@bar.com",
      timestamp: "1322000095",
      category: ["foo", "bar"]
    )

    actual = AttributeMapper.new(gridhook_event).to_hash

    actual[:email].should == "foo@bar.com"
    actual[:name].should == "sent"
    actual[:happened_at].should == Time.utc(2011,11,22, 22,14,55)
    actual[:category].should == ["foo", "bar"]
  end

  it "ignores smtp-id (we don't see the use)" do
    gridhook_event = Gridhook::Event.new(
      "smtp-id" => "foo"
    )

    actual = AttributeMapper.new(gridhook_event).to_hash
    actual.values.should_not include("foo")
  end

  # http://sendgrid.com/docs/API_Reference/Webhooks/event.html
  it "puts known attributes in data" do
    attributes = {
      attempt: "x",
      response: "x",
      url: "x",
      reason: "x",
      type: "x",
      status: "x"
    }

    gridhook_event = Gridhook::Event.new(attributes)
    actual = AttributeMapper.new(gridhook_event).to_hash

    actual[:data].should == attributes
  end

  # http://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html
  it "considers any additional attributes to be unique arguments" do
    gridhook_event = Gridhook::Event.new(
      email: "foo@bar.com",
      extra: "extra"
    )

    actual = AttributeMapper.new(gridhook_event).to_hash
    actual[:unique_args].should == { extra: "extra" }
  end
end
