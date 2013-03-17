Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = '/events'

  config.event_processor = proc do |event|
    # event is a Gridhook::Event object
    Rails.logger.info "GridHook event: #{event.attributes.inspect}"
  end
end
