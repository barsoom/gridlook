class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  def self.email(email)
    if email
      where(email: email)
    else
      all
    end
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

  def mailer_action
    Array(category).find { |c| c.include?("#") }
  end

  def smtp_id
    data[:"smtp-id"]
  end
end
