class ApiController < ApplicationController
  def events
    user_identifier = params[:user_identifier].presence || params[:user_id].presence

    unless user_identifier
      render status: 400, json: {
        error: "You have to specify user_identifier."
      }

      return
    end

    query = Event.
      where(user_identifier: user_identifier).
      recent_first

    query = query.where(mailer_action: params[:mailer_action]) if params[:mailer_action].present?
    query = query.where(name: params[:name]) if params[:name].present?

    events =
      query.
      # Pagination is required. A single user can potentially generate thousands of events.
      page(params[:page]).
      per(params[:per_page] || 25)

    render json: events.map { |event| serialize_event(event) }
  end

  def event
    event = Event.find(params[:id])
    render json: serialize_event(event)
  end

  private

  def serialize_event(event)
    {
      id: event.id,
      category: event.category,
      data: event.data,
      email: event.email,
      happened_at: event.happened_at,
      mailer_action: event.mailer_action,
      name: event.name,
      unique_args: event.unique_args,
      sendgrid_unique_event_id: event.sendgrid_unique_event_id,
      user_identifier: event.user_identifier,
    }
  end
end
