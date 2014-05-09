class Backup
  # Only keep the last six months of data
  TIME = 6.months.ago
  SQL_QUERY = "FROM events WHERE created_at < '#{TIME}'"
  FILENAME = "#{Rails.root}/tmp/events_older_than_#{TIME.to_s.split(" ").first}_exported_on_#{Time.now.to_s.split(" ").first}.csv"

  def export_and_delete
    return unless Date.today == Date.today.end_of_month

    if export
      upload
      delete
    else
      puts "Delete or/and Copy failed!"
    end
  end

  def export
    puts "Export events"
    excecute_sql(%Q[ COPY (SELECT * #{SQL_QUERY}) TO '#{FILENAME}' WITH CSV HEADER ])

    puts "Compress #{FILENAME}"
    system("gzip #{FILENAME}")
    puts "Compressed in #{FILENAME}.gz"

    File.exists?(FILENAME) # todo: count lines or something
  end

  def import
    puts "Import events"
    excecute_sql(%Q[ COPY events FROM '#{Rails.root}/tmp/#{args.filename}' WITH CSV HEADER ])
  end

  private

  def upload
    puts "Copy old data"
    #system("scp #{FILENAME} someserver:")
  end

  def delete
    puts "Delete old data"
    excecute_sql(%Q[ DELETE #{SQL_QUERY} ])
  end

  def excecute_sql(query)
    ActiveRecord::Base.connection.execute(query)
  end
end

namespace :backup do
  desc "Export and delete events older than six months"
  task export_and_delete: [ :environment, :export ] do
    backup.export_and_delete
  end

  desc "Export events to file"
  task :export => :environment do |t, args|
    backup.export
  end

  desc "Import events from file"
  task :import, [:filename] => :environment do |_, args|
    backup.import
  end

  private

  def backup
    Backup.new
  end
end
