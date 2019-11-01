class ApiController < ApplicationController
  def events
    user_type = params[:user_type].presence
    user_id = params[:user_id].presence

    unless user_type || user_id
      render status: 400, json: {
        error: "You have to specify user_type and user_id."
      }

      return
    end

    events = Event.
      where(user_type: user_type, user_id: user_id).
      recent_first

    render json: events.map { |event|
      {
        id: event.id,
        category: event.category,
        data: event.data,
        email: event.email,
        happened_at: event.happened_at,
        mailer_action: event.mailer_action,
        name: event.name,
        unique_args: event.unique_args,
        sendgrid_unique_event_id: event.sendgrid_unique_event_id
      }
    }
  end
end
