class ApiController < ApplicationController
  def events
    user_identifier = params[:user_identifier].presence || params[:user_id].presence

    unless user_identifier
      render status: 400, json: {
        error: "You have to specify user_identifier."
      }

      return
    end

    events = Event.
      where(user_identifier: user_identifier).
      with_name_if_present(params[:name].presence).
      with_mailer_action_if_present(params[:mailer_action].presence).
      with_associated_record_if_present(params[:associated_record].presence).
      page(params[:page]).per(params[:per_page] || 25).
      recent_first

    render json: events.map { |event| serialize_event(event) }
  end

  def event
    event = Event.find(params[:id])
    render json: serialize_event(event)
  end

  private

  def serialize_event(event)
    # NOTE: If you add, remove or rename keys, also change `GridlookEvent` in the Auctionet core repo to match.
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
      associated_records: event.associated_records,
    }
  end
end
