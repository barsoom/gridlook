require "spec_helper"

describe Event do
  describe "#email=" do
    it "downcases email" do
      event = Event.new(email: "FoO@ExAmplE.cOm")

      event.email.should == "foo@example.com"
    end
  end

  describe ".mailer_action" do
    it "finds an mailer action" do
      foo = Event.create!(mailer_action: "FooMailer#baz")

      Event.mailer_action("FooMailer#baz").should include(foo)
    end
  end

  describe ".mailer_actions" do
    before { Event.clear_cached_mailer_actions }

    it "lists sorted unique mailer actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: "BarMailer#foo")
      Event.create!(mailer_action: "FooMailer#baz")

      Event.mailer_actions.should == ["BarMailer#foo", "FooMailer#baz" ]
    end

    it "ignores nil actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: nil)

      Event.mailer_actions.should == [ "FooMailer#baz" ]
    end
  end

  describe ".email" do
    it "is case insensitive" do
      foo = Event.create!(email: "foo@example.com")

      Event.email("FOO@example.com").should include(foo)
    end
  end

  describe ".oldest_time" do
    it "is the time of the earliest event" do
      early_time = 2.days.ago
      later_time = 1.day.ago

      Event.create!(happened_at: later_time)
      Event.create!(happened_at: early_time)

      Event.oldest_time.to_i.should == early_time.to_i
    end

    it "is in the app-local time zone" do
      Event.create!(happened_at: Time.mktime(2013, 1, 1))
      Event.oldest_time.zone.should == Time.zone.name
    end

    it "handles nil" do
      Event.oldest_time.should be_nil
    end
  end

  describe ".newest_time" do
    it "is the time of the latest event" do
      early_time = 2.days.ago
      later_time = 1.day.ago

      Event.create!(happened_at: later_time)
      Event.create!(happened_at: early_time)

      Event.newest_time.to_i.should == later_time.to_i
    end

    it "is in the app-local time zone" do
      Event.create!(happened_at: Time.mktime(2013, 1, 1))
      Event.newest_time.zone.should == Time.zone.name
    end

    it "handles nil" do
      Event.newest_time.should be_nil
    end
  end
end
