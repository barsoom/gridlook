class RemoveEvents
  method_object :run

  def run
    destroy_events_older_than_six_months
  end

  private

  def destroy_events_older_than_six_months
    time = 6.months.ago
    Event.where("created_at < ?", time).destroy_all
    puts "Deleted events older than #{time}"
  end
end
