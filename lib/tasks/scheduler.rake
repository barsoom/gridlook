# This file contains all the heroku schedualer rake tasks.
# See: https://devcenter.heroku.com/articles/scheduler

desc "Postgres database tuning"
task database_tuning: :environment do
  puts "Tuning database."
  ActiveRecord::Base.connection.execute("VACUUM ANALYZE;")
  puts "Database tuning done."
end
