class RemoveEvents
  method_object

  def call
    destroy_events_older_than_the_limit
  end

  private

  def destroy_events_older_than_the_limit
    limit = 5.months.ago
    # We have no associated relations so we can use delete_all
    number_of_events_deleted = Event.where("created_at < ?", limit).delete_all
    EventsData.instance.decrement!(:total_events, number_of_events_deleted)
    puts "Deleted events older than #{limit}"
  end
end
