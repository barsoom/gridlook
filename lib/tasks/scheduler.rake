# This file contains all the heroku scheduler rake tasks.
# See: https://devcenter.heroku.com/articles/scheduler
require "tasks/remove_events"

namespace :scheduler do
  desc "Postgres database tuning"
  task database_tuning: :environment do
    puts "Tuning database."
    ActiveRecord::Base.connection.execute("VACUUM ANALYZE;")
    puts "Database tuning done."
  end

  desc "Remove events older than six months"
  task remove_events: :environment do
    RemoveEvents.call
  end
end
