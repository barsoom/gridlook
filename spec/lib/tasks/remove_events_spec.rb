require "rails_helper"
require "tasks/remove_events"

describe RemoveEvents, ".call" do
  let(:limit_in_months) { "22" }

  before do
    # No need for the logging output in the test
    allow_any_instance_of(RemoveEvents).to receive(:puts)
  end

  around do |test|
    ENV["NUMBER_OF_MONTHS_TO_KEEP_EVENTS_FOR"] = limit_in_months
    test.run
    ENV["NUMBER_OF_MONTHS_TO_KEEP_EVENTS_FOR"] = nil
  end

  it "removes data older than the limit and updates total events" do
    limit = limit_in_months.to_i.months.ago

    event_older_than_the_limit = Event.create!(happened_at: limit - 1.second)
    event_newer_than_the_limit = Event.create!(happened_at: limit + 1.second)
    expect(Event.count).to eq(2)  # Sanity
    expect(EventsData.total_events).to eq(2)  # Sanity

    RemoveEvents.call

    expect { event_older_than_the_limit.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect { event_newer_than_the_limit.reload }.not_to raise_error
    expect(EventsData.total_events).to eq(1)
  end

  it "remove campaign events" do
    event = Event.create!(unique_args: "campaign_id=1")
    expect(Event.count).to eq(1)  # Sanity
    expect(EventsData.total_events).to eq(1)  # Sanity

    RemoveEvents.call

    expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(EventsData.total_events).to eq(0)
  end

  it "keeps saved_search events for only 2 months" do
    limit = 2.months.ago

    event_older_than_the_limit = Event.create!(mailer_action: "SavedSearchMailer#build", happened_at: limit - 1.second)
    event_newer_than_the_limit = Event.create!(mailer_action: "SavedSearchMailer#build" , happened_at: limit + 1.second)
    expect(Event.count).to eq(2)  # Sanity
    expect(EventsData.total_events).to eq(2)  # Sanity

    RemoveEvents.call

    expect { event_older_than_the_limit.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect { event_newer_than_the_limit.reload }.not_to raise_error
    expect(EventsData.total_events).to eq(1)
  end
end
