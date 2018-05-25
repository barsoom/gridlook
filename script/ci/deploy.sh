#!/bin/bash

set -e

# Add config for heroku commands like "heroku config:set" and git based deploy over https
echo -e "machine api.heroku.com\n  login $HEROKU_API_USER\n  password $HEROKU_API_KEY\nmachine code.heroku.com\n  login $HEROKU_API_USER\n  password $HEROKU_API_KEY\nmachine git.heroku.com\n  login $HEROKU_API_USER\n  password $HEROKU_API_KEY" > ~/.netrc
chmod 0600 ~/.netrc

wget https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz 1> /dev/null
sudo mkdir -p /usr/local/lib /usr/local/bin
sudo tar -xvzf heroku-linux-amd64.tar.gz -C /usr/local/lib 1> /dev/null
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku
ssh-keyscan -H heroku.com >> ~/.ssh/known_hosts

# Deploy
revision=$(git rev-parse HEAD)
app_name=$1

function _main {
  _deploy_to_heroku
  _smoke_test
}

function _deploy_to_heroku {
  heroku git:remote --app $app_name

  # Workaround for https://github.com/travis-ci/dpl/issues/127#issuecomment-42397378
  git fetch --unshallow 2> /dev/null && true

  git push heroku master

  `git diff --exit-code HEAD $(heroku run 'echo "$GIT_COMMIT"' -a "$app_name") -- db/schema.rb` || {
    _run_migrations
  }

  heroku config:set GIT_COMMIT=$revision -a $app_name
}

function _smoke_test {
  ruby script/ci/support/wait_for_new_revision_to_serve_requests.rb $app_name $revision

  echo
  echo "Running smoke test."

  APP_URL=https://$app_name.herokuapp.com script/ci/smoke_test.sh
}

function _run_migrations {
  (heroku run 'rake db:migrate && echo HEROKU_OK' -a $app_name | grep HEROKU_OK)
    heroku restart -a $app_name  # So Rails picks up on column changes.
}

_main
