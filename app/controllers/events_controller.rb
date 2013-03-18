class EventsController < ApplicationController
  def index
    email = params[:email].to_s.strip.presence

    render locals: {
      count:  Event.count,
      email: email,
      events: Event.email(email).recent(100)
    }
  end
end
