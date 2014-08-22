require "rails_helper"

describe Event do
  describe "#email=" do
    it "downcases email" do
      event = Event.new(email: "FoO@ExAmplE.cOm")

      expect(event.email).to eq("foo@example.com")
    end
  end

  describe ".mailer_action" do
    it "finds an mailer action" do
      foo = Event.create!(mailer_action: "FooMailer#baz")

      expect(Event.mailer_action("FooMailer#baz")).to include(foo)
    end
  end

  describe ".mailer_actions" do
    before { Event.clear_cached_mailer_actions }

    it "lists sorted unique mailer actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: "BarMailer#foo")
      Event.create!(mailer_action: "FooMailer#baz")

      expect(Event.mailer_actions).to eq(["BarMailer#foo", "FooMailer#baz" ])
    end

    it "ignores nil actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: nil)

      expect(Event.mailer_actions).to eq([ "FooMailer#baz" ])
    end
  end

  describe ".email" do
    it "is case insensitive" do
      foo = Event.create!(email: "foo@example.com")

      expect(Event.email("FOO@example.com")).to include(foo)
    end
  end

  describe ".oldest_time" do
    it "is the time of the earliest event" do
      early_time = 2.days.ago
      later_time = 1.day.ago

      Event.create!(happened_at: later_time)
      Event.create!(happened_at: early_time)

      expect(Event.oldest_time.to_i).to eq(early_time.to_i)
    end

    it "is in the app-local time zone" do
      Event.create!(happened_at: Time.mktime(2013, 1, 1))
      expect(Event.oldest_time.zone).to eq(Time.zone.name)
    end

    it "handles nil" do
      expect(Event.oldest_time).to be_nil
    end
  end

  describe ".newest_time" do
    it "is the time of the latest event" do
      early_time = 2.days.ago
      later_time = 1.day.ago

      Event.create!(happened_at: later_time)
      Event.create!(happened_at: early_time)

      expect(Event.newest_time.to_i).to eq(later_time.to_i)
    end

    it "is in the app-local time zone" do
      Event.create!(happened_at: Time.mktime(2013, 1, 1))
      expect(Event.newest_time.zone).to eq(Time.zone.name)
    end

    it "handles nil" do
      expect(Event.newest_time).to be_nil
    end
  end

  describe ".total_events" do
    it "counts total events" do
      Event.create!

      expect(Event.total_events).to eq(1)
    end
  end

  describe "#description" do
    it "returns the description of an event type" do
      event = Event.new(name: "open")

      expect(event.description).to eq("Recipient has opened the HTML message.")
    end

    it "returns 'no description' when missing description" do
      event = Event.new(name: "foo")

      expect(event.description).to eq("No description")
    end
  end
end
