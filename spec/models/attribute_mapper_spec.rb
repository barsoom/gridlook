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

  it "parses arguments into a symbolized hash" do
    gridhook_event = Gridhook::Event.new(
      arguments: '{"foo": "bar"}'
    )

    actual = AttributeMapper.new(gridhook_event).to_hash
    actual[:arguments].should == { foo: "bar" }
  end

  it "puts remaining unknown attributes in data" do
    gridhook_event = Gridhook::Event.new(
      hello: "hello",
      world: "world"
    )

    actual = AttributeMapper.new(gridhook_event).to_hash
    actual[:data].should == {
      "hello" => "hello",
      "world" => "world"
    }
  end
end
