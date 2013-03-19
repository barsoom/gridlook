# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

if Rails.env.development?
  def local
    %w[foo bar baz].sample
  end

  def host
    %w[example.com bananas.com].sample
  end

  def event
    %w[
      processed dropped delivered deferred bounce
      open click spam_report unsubscribe
    ].sample
  end

  def time
    rand(1_000).minutes.ago
  end

  def categories
    %w[one two three four five six].sample(rand(3))
  end

  250.times do |i|
    Event.create!(
      email: "#{local}@#{host}",
      name: event,
      happened_at: time,
      arguments: { hello: "there" },
      category: categories,
      data: { url: "http://example.com/foo" }
    )
  end
end
