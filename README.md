
### Installation

Clone this directory and change into it. Run `bundle` to install all dependencies.

### Configuration

Configure Stripe account using ENV var `STRIPE_API_PRIVATE_KEY`

### Running locally

Since Sinatra Starter is configured to deploy on Heroku, a `Procfile` is included.

  web: bundle exec ruby app.rb -p $PORT

Use `foreman start -p XXXX` on your port of choice. For example:

  foreman start -p 3000

### Deploying

Configure an app for free on Heroku and follow their instructions on [deploying with Git](https://devcenter.heroku.com/articles/git).


