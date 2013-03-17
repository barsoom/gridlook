# gridlook

Rails 4 app on Heroku to log SendGrid webhook events.

Very WiP. Currently only saves to DB and shows a count on the (unsecured) root page; no UI beyond that.

But feel free to use `heroku run console` :)

Uses [gridhook](https://github.com/injekt/gridhook) to parse the events.

Since this is a tiny app, please do use it to experiment with technologies.

## Suggested things to play with
* Ember
* nosql (Mongo?)

## TODO
* Frontend to browse/search
* Secure frontend behind pw
* Ensure downtime free deploys so we don't lose data
* Use other APIs to check for stuff we missed in case we do lose data?
