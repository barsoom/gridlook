class RemoveEvents
  method_object

  # 64 GB storage limit on Heroku's Standard-0 plan.
  # We used ~8 GB for 3 months of data per 2016-11-18.
  # That makes 24 months, but mail amounts tend to grow, so let's be conservative.
  LIMIT = 22.months.ago

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
