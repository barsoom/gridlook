class AttributeMapper
  KNOWN_ATTRIBUTES = %w[
    smtp-id attempt response url reason type status
  ]

  def initialize(gridhook_event)
    @gridhook_event = gridhook_event
  end

  def to_hash
    @hash ||= begin
      {
        email:       attributes.delete(:email),
        name:        attributes.delete(:event),
        happened_at: timestamp,
        category:    attributes.delete(:category),
        data:        data,
        unique_args: attributes.symbolize_keys  # Whatever remains.
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

  def data
    known_attributes = attributes.slice(*KNOWN_ATTRIBUTES)
    KNOWN_ATTRIBUTES.each { |a| attributes.delete(a) }
    known_attributes.symbolize_keys
  end

  def attributes
    @attributes ||= @gridhook_event.attributes
  end
end
