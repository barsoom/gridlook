# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

if Rails.env.development?
  def local
    %w[fish dog cat camel horse cow capybara anteater badger badger badger badger mushroom mushroom].sample
  end

  def host
    %w[example.com bananas.com apples.com oranges.com grapes.com].sample
  end

  def event
    Event.names.sample
  end

  def time
    rand(1_000).minutes.ago
  end

  def mailer_action
    %w[FooMailer#fooed BarMailer#baared BazMailer#baazed].sample(1)[0]
  end

  250.times do |i|
    Event.create!(
      email: "#{local}@#{host}",
      name: event,
      mailer_action: mailer_action,
      happened_at: time,
      unique_args: { hello: "there", whats: "up" },
      data: { url: "http://example.com/foo", :"smtp-id" => rand(9999).to_s }
    )
  end
end
