# == Schema Information
#
# Table name: events
#
#  id                       :bigint(8)        not null, primary key
#  associated_records       :string           default([]), not null, is an Array
#  category                 :text
#  data                     :text
#  email                    :string
#  happened_at              :datetime
#  mailer_action            :string
#  name                     :string
#  unique_args              :text
#  user_identifier          :string
#  created_at               :datetime
#  updated_at               :datetime
#  sendgrid_unique_event_id :text
#
# Indexes
#
#  index_events_on_associated_records                    (associated_records) USING gin
#  index_events_on_email                                 (email)
#  index_events_on_happened_at_and_id                    (happened_at,id)
#  index_events_on_mailer_action_and_happened_at_and_id  (mailer_action,happened_at,id)
#  index_events_on_name                                  (name)
#  index_events_on_sendgrid_unique_event_id              (sendgrid_unique_event_id)
#  index_events_on_user_identifier                       (user_identifier)
#

class Event < ActiveRecord::Base
  # NOTE: We have a rake task (rake scheduler:remove_events) that uses delete_all, so if you introduce a relation that does not work with that make sure that you change the rake task as well.

  # Ignore user_id and user_type so we can remove them next deploy.
  self.ignored_columns = %w(user_id user_type)

  serialize :data
  serialize :category
  serialize :unique_args

  # Since we save email downcased, we make sure that all email query data also are downcased.
  scope :email, -> email { email ? where(email: email.downcase) : all }
  scope :named, -> name { name ? where(name: name) : all }
  scope :mailer_action, -> mailer_action { mailer_action ? where(mailer_action: mailer_action) : all }

  after_create :increment_events_counter

  EVENT_TYPES_WITH_DESCRIPTION =
    {
      processed:   "Message has been received and is ready to be delivered.",
      dropped:     "You may see the following drop reasons: invalid SMTPAPI header, spam content (if spam checker app enabled), unsubscribed address, bounced address, spam reporting address, invalid.",
      delivered:   "Message has been successfully delivered to the receiving server.",
      deferred:    "Recipient’s email server temporarily rejected message.",
      bounce:      "Receiving server could not or would not accept message.",
      open:        "Recipient has opened the HTML message.",
      click:       "Recipient clicked on a link within the message.",
      spamreport:  "Recipient marked message as spam.",
      unsubscribe: "Recipient clicked on message’s subscription management link.",
    }

  # We have a separate table for counting number or events,
  # this due to the fact that PostgreSQL is slow on counting large amounts of rows in a single table.
  def self.total_events
    EventsData.total_events
  end

  def self.recent(page, per)
    recent_first.page(page).per(per)
  end

  def self.recent_first
    order("happened_at DESC, id DESC")
  end

  def self.oldest_time
    time = minimum(:happened_at)
    time && time.in_time_zone
  end

  def self.newest_time
    time = maximum(:happened_at)
    time && time.in_time_zone
  end

  def self.names
    EVENT_TYPES_WITH_DESCRIPTION.keys.map(&:to_s)
  end

  # We use a recursive sql query to optimize picking unique mailer actions
  # Read more about it: http://zogovic.com/post/44856908222/optimizing-postgresql-query-for-distinct-values
  def self.mailer_actions
    sql = %q(
    WITH RECURSIVE t(n) AS (
        SELECT MIN(mailer_action) FROM events
      UNION
        SELECT (SELECT mailer_action FROM events WHERE mailer_action > n ORDER BY mailer_action LIMIT 1)
        FROM t WHERE n IS NOT NULL
    )
    SELECT n FROM t;
    )

    @mailer_actions ||= Event.connection.execute(sql).map { |mailer_action| mailer_action.flatten.last }.compact
  end

  def self.clear_cached_mailer_actions
    @mailer_actions = nil
  end

  def email=(value)
    super(value.to_s.downcase.presence)
  end

  def smtp_id
    data[:"smtp-id"]
  end

  def description
    EVENT_TYPES_WITH_DESCRIPTION.fetch(name.to_sym, "No description")
  end

  def unique_args
    (super || {}).symbolize_keys
  end

  private

  def increment_events_counter
    EventsData.increment
  end
end
