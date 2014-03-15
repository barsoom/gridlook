class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  # Since we save email downcased, we make sure that all email query data also are downcased.
  scope :email, -> email { email ? where(email: email.downcase) : all }
  scope :named, -> name { name ? where(name: name) : all }
  scope :mailer_action, -> mailer_action { mailer_action ? where(mailer_action: mailer_action) : all }

  # Track total event rows by implementing a trigger that keeps track on inserts/delets
  # Read more about it: http://www.varlena.com/GeneralBits/49.php
  def self.total_entries
    connection.select_value("SELECT total_rows FROM rowcount").to_i
  end

  def self.recent(page, per)
    order("happened_at DESC, id DESC").
      page(page).per(per)
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
    %w[
      processed dropped delivered deferred bounce
      open click spamreport unsubscribe
    ]
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
end
