class ApiController < ApplicationController
  def events
    user_id = params[:user_id].presence

    unless user_id
      render status: 400, json: {
        error: "You have to specify user_id."
      }

      return
    end

    # If we want to support other formats we should probably change how it's stored in the database.
    db_user_type, db_user_id = user_id.split(":")

    query = Event.
      where(user_type: db_user_type, user_id: db_user_id).
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
      sendgrid_unique_event_id: event.sendgrid_unique_event_id
    }
  end
end
