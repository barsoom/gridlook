class EventsController < ApplicationController
  PER_PAGE = 100

  def index
    email = params[:email].to_s.strip.presence
    page = params[:page]
    events = Event.email(email).recent(page, PER_PAGE)

    respond_to do |format|
      format.html {
        render locals: {
          count:  Event.count,
          first_time: Event.minimum(:happened_at),
          email: email,
          events: events
        }
      }
      format.json { render json: events.to_json }
    end
  end
end
