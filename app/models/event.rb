class Event < ActiveRecord::Base
  serialize :arguments
  serialize :category
  serialize :data

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
end
