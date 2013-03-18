class EventsController < ApplicationController
  PER_PAGE = 100

  def index
    email = params[:email].to_s.strip.presence
    page = params[:page]

    render locals: {
      count:  Event.count,
      email: email,
      events: Event.email(email).recent(page, PER_PAGE)
    }
  end
end
