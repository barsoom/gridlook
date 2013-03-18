Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/events'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    as = event.attributes.except(:"smtp-id")

    Rails.logger.info "GridHook event: #{as.inspect}"

    # We get these as a JSON string.
    arguments = JSON.parse(as.delete(:arguments)).symbolize_keys

    Event.create!(
      email:       as.delete(:email),
      name:        as.delete(:event),
      happened_at: event.timestamp,  # Parsed for us.
      arguments:   arguments,
      category:    as.delete(:category),
      data:        as.except(:timestamp)
    )
  end
end
