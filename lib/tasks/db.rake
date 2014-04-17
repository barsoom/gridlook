namespace :db do
  # Only keep the last six months of data
  TIME = 6.months.ago
  SQL_QUERY = "FROM events WHERE created_at < '#{TIME}'"
  FILENAME = "#{Rails.root}/tmp/events_older_than_#{TIME.to_s.split(" ").first}_exported_on_#{Time.now.to_s.split(" ").first}.csv"

  desc "Export and delete events older than six months"
  task export_and_delete: [ :environment, :export ] do
    # only export and delete at the end of the month§
    return unless Date.today == Date.today.end_of_month

    if File.size?(FILENAME)
      puts "Delete old data"
      excecute_sql(%Q[ DELETE #{SQL_QUERY} ])

      puts "Copy old data"
      #system("scp #{FILENAME} someserver:")
    else
      puts "Delete or/and Copy failed!"
    end
  end

  desc "Export events to file"
  task :export => :environment do |t, args|
    puts "Export events"
    excecute_sql(%Q[ COPY (SELECT * #{SQL_QUERY}) TO '#{FILENAME}' WITH CSV HEADER ])

    puts "Compress #{FILENAME}"
    system("gzip #{FILENAME}")
  end

  desc "Import events from file"
  task :import, [:filename] => :environment do |_, args|
    puts "Import events"
    excecute_sql(%Q[ COPY events FROM '#{Rails.root}/tmp/#{args.filename}' WITH CSV HEADER ])
  end

  def excecute_sql(query)
    ActiveRecord::Base.connection.execute(query)
  end
end
