class EventsController < ApplicationController
  PER_PAGE = 100

  def index
    email = params[:email].to_s.strip.presence
    name = params[:name].to_s.strip.presence
    page = params[:page]

    if email
      events = Event.email(email).recent(page, PER_PAGE)
    elsif name
      events = Event.filter_on_event(name).recent(page, PER_PAGE)
    else
      events = Event.all.recent(page, PER_PAGE)
    end

    render locals: {
      count:  Event.count,
      newest_time: Event.newest_time,
      oldest_time: Event.oldest_time,
      email: email,
      name: name,
      events: events
    }
  end
end
