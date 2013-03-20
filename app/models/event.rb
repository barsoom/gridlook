class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  # TODO: remove
  serialize :arguments

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

  def self.first_time
    time = minimum(:happened_at)
    time && time.in_time_zone
  end

  def mailer_action
    Array(category).find { |c| c.include?("#") }
  end
end
