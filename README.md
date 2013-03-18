# gridlook

Rails 4 app on Heroku to log SendGrid webhook events.

Very WiP currently! Logs but needs a proper UI. Feel free to use `heroku run console` for now :)

Uses [gridhook](https://github.com/injekt/gridhook) to parse the events.

## Installation

Check out this repo (clone it first if you like).

Create and set up a Heroku app:

```
heroku create my-gridlook  # Choose a better name.

# Set up DB per https://devcenter.heroku.com/articles/heroku-postgresql
# If you're not cheap and know you'll need more than you get with the free plan,
# you might want to set up another plan and save yourself the bother of a plan migration.
heroku addons:add heroku-postgresql:dev
heroku config | grep HEROKU_POSTGRESQL  # See what ENV was used for this DB.
heroku pg:promote HEROKU_POSTGRESQL_RED_URL  # Replace "RED" with whatever ENV was used.

# Configure HTTP auth.
heroku config:set HTTP_USER=aladdin HTTP_PASSWORD=sesame
# Configure Rails secret key (not actually used yet).
heroku config:set SECRET_KEY_BASE=`rake secret`
# Configure Rails time zone.
heroku config:set RAILS_TZ=CET  # Whatever you prefer.

# Deploy app.
heroku push

# Open app in browser.
heroku open
```

Note that this sets you up for the free Postgres plan which has a maximum of 10 000 rows. You may need to change plans pretty quick if you send a lot of mail. Each mail may generate several rows, one per mail event.

Now your app is deployed. The next step is to configure SendGrid. Follow [their setup instructions](http://sendgrid.com/docs/API_Reference/Webhooks/event.html).

Don't forget to both configure and enable the app.

The URL you configure should be something like `https://aladdin:sesame@my-gridlook.herokuapp.com/events`. Make sure to use your own values for HTTP auth username, password, and the Heroku app name.

As long as you use Heroku, you get https for free. If you use your own domain, you need to [set stuff up](https://devcenter.heroku.com/articles/ssl).

That should be it. SendGrid should start sending you events and your app should start logging and showing them.

## Notes

Don't worry about deploy downtime etc: SendGrid will retry:

> SendGrid expects a 200 HTTP response to the POST, otherwise the event notification will be retried.
> If your URL returns a non-200 HTTP code it will be deferred and retried for 24 hours.

## Non-obvious places in the app
* `config/initializers/gridhook.rb` handles incoming events.
* `config/environments/production.rb` sets up HTTP auth.

## Development

    script/bootstrap
    # todo: add tests

## TODO
* Tests
  * Auth is applied in prod
  * Creating one event works
  * UI works given events in DB
* Pagination
* Frontend to browse/search properly
* Slim templates
* Nicer markup
* Styling
* Verify that migration works on a new app (was iffy on this one)
