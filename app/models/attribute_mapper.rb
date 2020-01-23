class AttributeMapper
  KNOWN_ATTRIBUTES = %w[
    smtp-id attempt response url reason type status
  ]

  def initialize(gridhook_event)
    @gridhook_event = gridhook_event
  end

  def to_hash
    user_identifier = attributes.delete(:user_identifier) || attributes.delete(:user_id)
    associated_records = attributes.delete(:associated_records)

    @hash ||= begin
      {
        email:           attributes.delete(:email),
        name:            attributes.delete(:event),
        happened_at:     timestamp,
        mailer_action:   mailer_action(attributes[:category]),
        category:        attributes.delete(:category),
        data:            data,
        user_identifier: user_identifier,
        associated_records: associated_records ? JSON.parse(associated_records) : [],
        unique_args:     attributes.symbolize_keys  # Whatever remains.
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

  def mailer_action(categories)
     categories.find { |c| c.include?("#") } if categories
  end
end
