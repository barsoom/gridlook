[![Build Status](https://secure.travis-ci.org/barsoom/gridlook.png)](http://travis-ci.org/barsoom/gridlook)
# gridlook

Rails 4 app on Heroku to log SendGrid webhook events.

It improves on SendGrid's email activity page in these ways:

  * The history is not truncated (unless you truncate it yourself)
  * Filtering on an address is a GET with a query parameter, so you can link from internal systems
  * Shows more useful information if you follow some conventions

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
heroku config:set HTTP_USER=alibaba HTTP_PASSWORD=sesame
# Configure Rails secret key (not actually used yet).
heroku config:set SECRET_KEY_BASE=`rake secret`
# Configure Rails time zone.
heroku config:set RAILS_TZ=CET  # Whatever you prefer.

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

The URL you configure should be something like `https://alibaba:sesame@my-gridlook.herokuapp.com/events`. Make sure to use your own values for HTTP auth username, password, and the Heroku app name.

As long as you use Heroku, you get https for free. If you use your own domain, you need to [set stuff up](https://devcenter.heroku.com/articles/ssl).

That should be it. SendGrid should start sending you events and your app should start logging and showing them.

## More information with conventions

If you [configure your mails](http://henrik.nyh.se/2012/08/sendgrid-metadata-and-rails/) to include the mailer as a category containing a "#", e.g. "CustomerMailer#signup", that information will be shown at the top and can be filtered.

## Notes

Don't worry about deploy downtime etc. SendGrid [will retry](http://sendgrid.com/docs/API_Reference/Webhooks/event.html#-Requests):

> SendGrid expects a 200 HTTP response to the POST, otherwise the event notification will be retried.
> If your URL returns a non-200 HTTP code it will be deferred and retried for 24 hours.

The license for SendGrid's event icons is unclear. We asked and received no response. We will replace them if they complain.

Non-obvious places in the app:

* `config/initializers/gridhook.rb` handles incoming events.
* `config/environments/production.rb` sets up HTTP auth.

## Development

    script/bootstrap
    rake db:setup
    rake  # Run tests

## Maintenance

Some useful commands working with heroku:
```
heroku pg:psql # database console

# Needs to be installed as a heroku addon (pgbackups)
heroku pgbackups:capture # database backup
heroku pgbackups:url # get an download url to the latest backup
curl -L <url> -o $(date +%y-%m-%d)\_gridlook_db # Download <url> (url given by heroku pgbackups:url) with format: year-month-day_gridlook_db

# Sometimes it's nice to get more info in the production server log.
heroku config:add LOG_LEVEL="<level>" # level = info/debug
heroku logs -t # Show log tailed

heroku run console # Rails console
```
## TODO

* Tests that auth is applied in prod

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
