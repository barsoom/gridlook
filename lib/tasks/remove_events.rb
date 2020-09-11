class RemoveEvents
  method_object

  def call
    destroy_events_older_than_the_limit
  end

  private

  def destroy_events_older_than_the_limit
    return unless event_retention_setting.present?

    remove_events_for_scope(Event.where("happened_at < ?", general_limit))
    puts "Deleted events older than #{general_limit}"

    # Some events are less important than others
    remove_events_for_scope(Event.where(mailer_action: "SavedSearchMailer#build").where("happened_at < ?", short_limit))
    remove_events_for_scope(Event.where("unique_args LIKE '%campaign_id%'").where("happened_at < ?", short_limit))
    puts "Deleted short-lived-events older than #{short_limit}"
  end

  def remove_events_for_scope(scope)
    # We have no associated relations so we can use delete_all
    number_of_events_deleted = scope.delete_all
    lower_number_of_event_counter(number_of_events_deleted)
  end

  def lower_number_of_event_counter(count)
    EventsData.instance.decrement!(:total_events, count)
  end

  def general_limit
    event_retention_setting.to_i.months.ago
  end

  def short_limit
    (event_retention_setting.to_i / 2).months.ago
  end

  def event_retention_setting
    ENV.fetch("NUMBER_OF_MONTHS_TO_KEEP_EVENTS_FOR", nil)
  end
end
