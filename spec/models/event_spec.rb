require "spec_helper"

describe Event do
  describe "#email=" do
    it "downcases email" do
      event = Event.new(email: "FoO@ExAmplE.cOm")

      event.email.should == "foo@example.com"
    end
  end

  describe ".email" do
    it "is case insensitive" do
      foo = Event.create!(email: "foo@example.com")

      Event.email("FOO@example.com").should include(foo)
    end
  end

  describe "#mailer_action" do
    it "finds the first matching category" do
      Event.new(category: ["hello#world", "x#y"]).mailer_action.should == "hello#world"
    end

    it "is nil with no mailer action category" do
      Event.new(category: ["hello"]).mailer_action.should be_nil
    end

    it "is nil with no categories" do
      Event.new(category: nil).mailer_action.should be_nil
    end
  end

  describe ".oldest_time" do
    it "is the time of the earliest event" do
      early_time = 2.days.ago
      later_time = 1.day.ago
      Event.create!(happened_at: later_time)
      Event.create!(happened_at: early_time)

      Event.oldest_time.should == early_time
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

      Event.newest_time.should == later_time
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
