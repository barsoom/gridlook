# Deploys all apps listed in HEROKU_APP_NAMES

# How it works:

# - HEROKU_APP_NAMES contains a list of heroku app names separated by comma, e.g. "foo,bar,baz"
# - sed splits the list into one line per app, e.g. "foo", then "bar", then "baz"
# - xargs runs the deploy script for each app (the name of the current app is the variable "{}")

echo $HEROKU_APP_NAMES | sed s/,/\\n/g | xargs -I {} script/ci/pipeline.sh {}_deploy "script/ci/deploy.sh {}"
