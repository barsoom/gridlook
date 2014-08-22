class EventsData < ActiveRecord::Base
  def self.total_events
    EventsData.instance.total_events
  end

  def self.increment
    EventsData.instance.increment!(:total_events)
  end

  def self.instance
    EventsData.first_or_create(total_events: 0)
  end
end
