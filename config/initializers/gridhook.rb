Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/events'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    as = event.attributes.except(:environment, :"smtp-id")

    Rails.logger.info "GridHook event: #{as.inspect}"

    Event.create!(
      email:       as.delete(:email),
      name:        as.delete(:event),
      happened_at: event.timestamp,  # Parsed for us.
      arguments:   as.delete(:arguments),
      category:    as.delete(:category),
      data:        as.except(:timestamp)
    )
  end
end
