class Event < ActiveRecord::Base
  serialize :arguments
  serialize :category
  serialize :data

  def self.email(email)
    if email
      where(email: email)
    else
      scoped
    end
  end

  def self.recent(count)
    order("happened_at DESC, id DESC").
      limit(count)
  end
end
