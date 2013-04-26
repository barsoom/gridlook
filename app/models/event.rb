class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  scope :email, -> email { email ? where(email: email) : all }
  scope :named, -> name { name ? where(name: name) : all }

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
