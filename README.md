[![CircleCi](https://circleci.com/gh/barsoom/gridlook.svg?style=shield)](https://circleci.com/gh/barsoom/gridlook)
[![Dependency Status](https://gemnasium.com/badges/github.com/barsoom/gridlook.svg)](https://gemnasium.com/github.com/barsoom/gridlook)

# Gridlook

Rails 5 app on Heroku to log SendGrid webhook events.

It improves on SendGrid's email activity page in these ways:

  * The history is not truncated (unless you truncate it yourself)
  * Filtering on an address is a GET with a query parameter, so you can link from internal systems
  * Shows more useful information if you follow some conventions

Uses [gridhook](https://github.com/injekt/gridhook) to parse the events.

NOTE for Auctionet devs: As of 2020-01-22 we experimentally use [ex-gridhook](https://github.com/barsoom/ex_gridhook) to receive events more performantly. The [SendGrid event webhook](https://app.sendgrid.com/settings/mail_settings) might be configured to only post to ex-gridhook, and not to Gridlook. Gridlook is still used to view the event log.

Has some support for [outbound.io](https://www.outbound.io/) metadata.

## API

As long as you pass in `user_identifier` to `unique_args` in sendgrid headers you can get event data via this API (`user_id` is also supported due to outbound, but is saved as `user_identifier`).

The API uses basic auth (configured with `HTTP_USER` and `HTTP_PASSWORD`).

    curl -u user:password http://example.com/api/v1/events?user_id=Customer:123

You can also get data about any event as long as you know it's id.

    curl -u user:password http://example.com/api/v1/events/123

## Installation

Check out this repo (clone it first if you like).

Create and set up a Heroku app:

```bash
heroku create my-gridlook  # Choose a better name.

# Set up DB per https://devcenter.heroku.com/articles/heroku-postgresql
# If you're not cheap and know you'll need more than you get with the free plan,
# you might want to set up another plan and save yourself the bother of a plan migration.
heroku addons:add heroku-postgresql:dev
heroku config | grep HEROKU_POSTGRESQL  # See what ENV was used for this DB.
heroku pg:promote HEROKU_POSTGRESQL_RED_URL  # Replace "RED" with whatever ENV was used.

# Configure HTTP auth.
heroku config:set HTTP_USER=alibaba HTTP_PASSWORD=sesame
# ^ there is also JWT (Json Web Token) auth, see spec/features/jwt_authentication_spec.rb

# Configure Rails secret key (not actually used yet).
heroku config:set SECRET_KEY_BASE=`rake secret`
# Configure Rails time zone.
heroku config:set RAILS_TZ=CET  # Whatever you prefer.

# Optional custom header:
# heroku config:set CUSTOM_HTML_HEADER="<div>Your custom header on top of the page, can include ERB like <%= params[:action] %></div>"
#
# ^ One thing this can be used for is to display JWT data, see the jwt_authentication gem for docs on the available session data.

# Deploy app.
git push heroku

# Load DB schema.
heroku run rake db:schema:load

# Open app in browser.
heroku open
```

Note that this sets you up for the free Postgres plan which has a maximum of 10 000 rows. You may need to change plans pretty quick if you send a lot of mail. Each mail may generate several rows, one per mail event.

Now your app is deployed. The next step is to configure SendGrid. Follow [their setup instructions](http://sendgrid.com/docs/API_Reference/Webhooks/event.html).

Don't forget to both configure and enable the app.

Hit "Select all" if you want all events. Enable batch event notifications.

The URL you configure should be something like `https://alibaba:sesame@my-gridlook.herokuapp.com/events`. Make sure to use your own values for HTTP auth username, password, and the Heroku app name.

As long as you use Heroku, you get https for free. If you use your own domain, you need to [set stuff up](https://devcenter.heroku.com/articles/ssl).

That should be it. SendGrid should start sending you events and your app should start logging and showing them.

## More information with conventions

If you [configure your mails](http://thepugautomatic.com/2012/08/sendgrid-metadata-and-rails/) to include the mailer as a category containing a "#", e.g. "CustomerMailer#signup", that information will be shown at the top and can be filtered.

## Notes

Don't worry about deploy downtime etc. SendGrid [will retry](http://sendgrid.com/docs/API_Reference/Webhooks/event.html#-Requests):

> SendGrid expects a 200 HTTP response to the POST, otherwise the event notification will be retried.
> If your URL returns a non-200 HTTP code it will be deferred and retried for 24 hours.

The license for SendGrid's event icons is unclear. We asked and received no response. We will replace them if they complain.

Non-obvious places in the app:

* `config/initializers/gridhook.rb` handles incoming events.
* `config/environments/production.rb` sets up HTTP auth.

Also note that Gridlook uses Postgres-specific DB triggers (to show an accurate event count).

## Development
```bash
script/bootstrap
rake  # Run tests
```
## Maintenance

Some useful commands working with heroku:
```bash
heroku pg:psql # database console

# Needs to be installed as a heroku addon (pgbackups)
heroku pg:backups capture # database backup
heroku pg:backups public-url # get an download url to the latest backup
curl -L <url> -o $(date +%y-%m-%d)\_gridlook_db # Download <url> (url given by heroku pg:backups public-url) with format: year-month-day_gridlook_db

# Sometimes it's nice to get more info in the production server log.
heroku config:add LOG_LEVEL="<level>" # level = info/debug
heroku logs -t # Show log tailed

heroku run console # Rails console
```

### Heroku Scheduler

You can use [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) for some recurring tasks.

You find the scheduler dashboard [here](https://scheduler.heroku.com/dashboard).

Gridlook defines some Rake task suitable for scheduling, [here](https://github.com/barsoom/gridlook/blob/master/lib/tasks/scheduler.rake).

#### Auto tuning

If you find that some queries are slow or that you have other db issues it could be smart to set up some auto tuning of the postgres db.

Auto tuning is done to clean the postgres database and also help the db planner (caching and so on). Read more about it [here](https://devcenter.heroku.com/articles/heroku-postgres-database-tuning).

If you want this, you may schedule `rake scheduler:database_tuning` to run e.g. daily.


#### Remove events older than a limit

If you have a limited heroku db plan and a lot of events coming in, you will sooner or later need to delete old events.

To automate that, you may schedule `rake scheduler:remove_events` to run e.g. hourly.

To be able to limit the number of events, just set `NUMBER_OF_MONTHS_TO_KEEP_EVENTS_FOR`. Example: `heroku config:set NUMBER_OF_MONTHS_TO_KEEP_EVENTS_FOR="10"  # Keep events that are created ten months ago or newer`.

## Also see

* [Postman](https://github.com/mynewsdesk/postman), backed by [keen.io](https://keen.io). May cost significantly more than Gridlook/Heroku Postgres for large event volumes.

## Contributors

[Barsoom](http://barsoom.se)

[Johan Lundström](https://github.com/johanlunds)

## Credits and license

By [Barsoom](http://barsoom.se) under the MIT license:

>  Copyright (c) 2012 Barsoom AB
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
