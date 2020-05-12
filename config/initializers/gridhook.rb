Gridhook.configure do |config|
  # The path we want to receive events
  config.event_receive_path = "/events"
  config.event_processor = EventProcessor.new
end
