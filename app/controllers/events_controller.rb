class EventsController < ApplicationController
  PER_PAGE = 100

  def index
    email = params[:email].to_s.strip.presence
    name = params[:name].to_s.strip.presence
    mailer_action = params[:mailer_action].to_s.strip.presence
    associated_record = params[:associated_record].to_s.strip.presence
    page = params[:page] || 1

    filtered_events = Event
      .with_email_if_present(email)
      .with_name_if_present(name)
      .with_mailer_action_if_present(mailer_action)
      .with_associated_record_if_present(associated_record)

    events_on_page = filtered_events.recent(page, PER_PAGE)

    render locals: {
      total_count: Event.total_events,
      newest_time: Event.newest_time,
      oldest_time: Event.oldest_time,
      email: email,
      name: name,
      mailer_action: mailer_action,
      associated_record: associated_record,
      events: events_on_page,
      page: page.to_i,
    }
  end
end
