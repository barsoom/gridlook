# Wait for DB to be available (since it starts in parallel with preparing to run tests)
# https://circleci.com/docs/2.0/postgres-config/#using-dockerize
echo "Waiting for postgres to be ready..."
dockerize -wait tcp://localhost:5432 -timeout 1m

echo
echo "Creating database and loading schema..."
RAILS_ENV=test bundle exec rake db:create db:schema:load
