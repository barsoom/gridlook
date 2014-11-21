class RemoveEvents
  method_object :run

  def run
    destroy_events_older_than_six_months
  end

  private

  def destroy_events_older_than_six_months
    time = 6.months.ago
    # We have no associated relations so we can use delete_all
    number_of_events_deleted = Event.where("created_at < ?", time).delete_all
    update_total_events(number_of_events_deleted)
    puts "Deleted events older than #{time}"
  end

  def update_total_events(number_of_events_deleted)
    old_total_events = EventsData.total_events
    EventsData.instance.decrement!(:total_events, old_total_events - number_of_events_deleted)
  end
end
