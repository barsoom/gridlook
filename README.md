# gridlook

Rails 4 app on Heroku to log SendGrid webhook events.

See e.g. <http://gridlook.herokuapp.com>. HTTP auth details on wiki.

Very WiP. Needs a proper UI. Feel free to use `heroku run console` :)

Uses [gridhook](https://github.com/injekt/gridhook) to parse the events.

Don't worry about deploy downtime etc: SendGrid will retry:

> SendGrid expects a 200 HTTP response to the POST, otherwise the event notification will be retried.
> If your URL returns a non-200 HTTP code it will be deferred and retried for 24 hours.

The app is configured to use HTTP auth in prod. Make sure to set those ENVs in Heroku, and to configure SendGrid to provide the auth (configure a URL like `http://user:password@yoursite.com/events`).

Since this is a tiny app, please do use it to experiment with technologies.

## Non-obvious places in the app:
* `config/initializers/gridhook.rb` handles incoming events.
* `config/environments/production.rb` sets up HTTP auth.

## Suggested things to play with
* Ember
* nosql (Mongo?)

## TODO
* Frontend to browse/search properly
* Ensure downtime free deploys so we don't lose data
* Use other APIs to check for stuff we missed in case we do lose data?
