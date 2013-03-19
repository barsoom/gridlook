namespace :spec do
  desc 'Run javascript unit tests'
  task :js => [ :js_message, :'konacha:run' ] do
  end

  task :js_message do
    puts "Running javascript unit tests..."
  end
end

task :default => [ :spec, :'spec:js' ]
