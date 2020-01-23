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

    # This is an array column. The `? = ANY(associated_records)` syntax seems to always use a sequential scan and ignore the index on this column.
    query = query.where("associated_records @> ?", "{\"#{params[:associated_record]}\"}") if params[:associated_record].present?

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

      # Disabled 2020-01-23 to fix https://app.honeybadger.io/projects/250/faults/59891750 when Auctionet core was not deployable. Should be restored as soon as core has been deployed.
      #associated_records: event.associated_records,
    }
  end
end
