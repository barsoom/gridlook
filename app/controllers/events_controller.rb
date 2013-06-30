class EventsController < ApplicationController
  PER_PAGE = 100

  def index
    email         = params[:email].to_s.strip.presence
    name          = params[:name].to_s.strip.presence
    mailer_action = params[:mailer_action].to_s.strip.presence
    page          = params[:page] || 1

    filtered_events = Event.
      email(email).
      named(name).
      mailer_action(mailer_action)
    events_on_page = filtered_events.recent(page, PER_PAGE)

    render locals: {
      total_count:    Event.total_entries,
      newest_time:    Event.newest_time,
      oldest_time:    Event.oldest_time,
      email:          email,
      name:           name,
      mailer_action:  mailer_action,
      events:         events_on_page,
      page:           page.to_i
    }
  end
end
