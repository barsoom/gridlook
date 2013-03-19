namespace :app do
  desc "Reset development and test env"
  task :reset => [ :'db:drop', :'db:create', :'db:migrate', :'db:test:prepare' ] do
  end
end
