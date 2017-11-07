workers Integer(ENV["WEB_CONCURRENCY"] || 2)
threads_count = Integer(ENV["RAILS_MAX_THREADS"] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV["PORT"]     || 3000
environment ENV["RACK_ENV"] || "development"

before_fork do
  PumaWorkerKiller.config do |config|
    config.ram           = 512                    # mb (size of a 1x Heroku dyno)
    config.frequency     = 10                     # seconds (check every 10 seconds)
    config.percent_usage = 0.98                   # restart when 98% of total memory is used
    config.rolling_restart_frequency = 12 * 3600  # 12 hours in seconds (restart all workers every 12 hours)
  end

  PumaWorkerKiller.start
end
