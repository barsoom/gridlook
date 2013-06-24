class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  # Since we save email downcased, we make sure that all email query data also are downcased.
  scope :email, -> email { email ? where(email: email.downcase) : all }
  scope :named, -> name { name ? where(name: name) : all }

  def category=(value)
    self.mailer_action = Array(value).find { |c| c.include?("#") }
    super
  end

  def email=(value)
    super(value.to_s.downcase.presence)
  end

  def self.recent(page, per)
    order("happened_at DESC, id DESC").
      page(page).per_page(per)
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

  def mailer_action
    Array(category).find { |c| c.include?("#") }
  end

  def smtp_id
    data[:"smtp-id"]
  end
end
