class EventProcessor
  def call(gridhook_event)
    attributes = AttributeMapper.new(gridhook_event).to_hash
    Event.create!(attributes)
  end
end
