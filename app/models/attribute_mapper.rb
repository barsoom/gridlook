class AttributeMapper
  def initialize(gridhook_event)
    @gridhook_event = gridhook_event
  end

  def to_hash
    @hash ||= begin
      # Boring!
      attributes.delete(:"smtp-id")

      {
        email:       attributes.delete(:email),
        name:        attributes.delete(:event),
        happened_at: timestamp,
        arguments:   arguments,
        category:    attributes.delete(:category),
        data:        attributes  # Whatever remains.
      }
    end
  end

  private

  def timestamp
    # Preparsed.
    timestamp = @gridhook_event.timestamp
    attributes.delete(:timestamp)
    timestamp
  end

  def arguments
    raw_arguments = attributes.delete(:arguments)
    raw_arguments && JSON.parse(raw_arguments).symbolize_keys
  end

  def attributes
    @attributes ||= @gridhook_event.attributes
  end
end
