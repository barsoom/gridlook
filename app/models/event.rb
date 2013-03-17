class Event < ActiveRecord::Base
  serialize :arguments
  serialize :category
  serialize :data
end
