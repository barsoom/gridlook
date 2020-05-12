require "rails_helper"

describe Event do
  describe "#email=" do
    it "downcases email" do
      event = Event.new(email: "FoO@ExAmplE.cOm")

      expect(event.email).to eq("foo@example.com")
    end
  end

  describe ".with_mailer_action_if_present" do
    it "finds by mailer action" do
      foo = Event.create!(mailer_action: "FooMailer#baz")
      bar = Event.create!(mailer_action: "BarMailer#baz")

      expect(Event.with_mailer_action_if_present("FooMailer#baz")).to contain_exactly(foo)
      expect(Event.with_mailer_action_if_present(nil)).to contain_exactly(foo, bar)
    end
  end

  describe ".mailer_actions" do
    before { Event.clear_cached_mailer_actions }

    it "lists sorted unique mailer actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: "BarMailer#foo")
      Event.create!(mailer_action: "FooMailer#baz")

      expect(Event.mailer_actions).to eq([ "BarMailer#foo", "FooMailer#baz" ])
    end

    it "ignores nil actions" do
      Event.create!(mailer_action: "FooMailer#baz")
      Event.create!(mailer_action: nil)

      expect(Event.mailer_actions).to eq([ "FooMailer#baz" ])
    end
  end

  describe ".with_email and .with_email_if_present" do
    it "is case insensitive" do
      foo = Event.create!(email: "foo@example.com")

      expect(Event.with_email("FOO@example.com")).to include(foo)
      expect(Event.with_email_if_present("FOO@example.com")).to include(foo)
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

  describe "#unique_args" do
    it "returns the unique arguments of an event with symbolized keys" do
      unique_args = { "ip" => "192.254.122.68" }
      event = Event.new(unique_args: unique_args)

      expect(event.unique_args).to eq(ip: "192.254.122.68")
    end

    it "returns an empty hash" do
      event = Event.new(unique_args: nil)

      expect(event.unique_args).to eq({})
    end
  end
end
