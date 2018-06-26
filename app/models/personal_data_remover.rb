# To be used for GDPR removal requests. Read more: https://github.com/barsoom/auctionet/blob/master/developer_documentation/hatter.md#handle-a-customer-deletion-request

class PersonalDataRemover
  def self.call(email)
    removed_count = Event.email(email).delete_all
    EventsData.decrement(removed_count)
  end
end
