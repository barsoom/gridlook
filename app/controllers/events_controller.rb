class EventsController < ApplicationController
  def index
    render locals: {
      count:  Event.count,
      events: Event.recent(100)
    }
  end
end
