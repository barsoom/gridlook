# == Schema Information
#
# Table name: events_data
#
#  id           :bigint(8)        not null, primary key
#  total_events :integer
#

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
