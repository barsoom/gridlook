class RemoveEvents
  method_object

  LIMIT = 4.months.ago

  def call
    destroy_events_older_than_the_limit
  end

  private

  def destroy_events_older_than_the_limit
    # We have no associated relations so we can use delete_all
    number_of_events_deleted = Event.where("happened_at < ?", LIMIT).delete_all
    EventsData.instance.decrement!(:total_events, number_of_events_deleted)
    puts "Deleted events older than #{LIMIT}"
  end
end
