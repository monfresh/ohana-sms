# Ohana SMS

Ohana SMS is a Ruby on Rails application that allows people in need who lack
access to the internet to find human services via SMS.

By default, Ohana SMS is able to query any [Ohana API][ohana-api] instance,
but it can be modified to work with any API.

[ohana-api]: https://github.com/codeforamerica/ohana-api

## Stack Overview

* Ruby version 2.2.0
* Rails version 4.2.0
* Testing Frameworks: MiniTest

## Local Installation

### Prerequisites
You'll need a Ruby development environment on your computer, and a Twilio account.

#### Ruby
If you're on a Mac, the easiest way to get up and running is to run my [laptop script](https://github.com/monfresh/laptop). On Linux, you'll need to install [Build tools][build-tools], [Ruby with RVM][ruby],
and [Node.js][node].

Once your environment is ready to go, install the app:

```
git clone git@github.com:monfresh/ohana-sms.git && cd ohana-sms
bin/setup
```

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md

#### Twilio
1. Sign up for a [free Twilio account](http://twilio.com/try-twilio).
2. Once logged in to your Twilio account, visit the [Account Settings][settings]
page.
3. Copy your Test AccountSID and paste it in `config/application.yml`
next to `twilio_account_sid`.
4. Copy your Test AuthToken and paste it in `config/application.yml`
next to `twilio_auth_token`.
5. Enter your Twilio phone number (including the `+1`) next to `twilio_number`.

[settings]: https://www.twilio.com/user/account/settings
[manage]: https://www.twilio.com/user/account/phone-numbers/incoming

## Deploy to Heroku and test the app

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Running the tests

Run tests locally with this simple command:

    script/test

To see the actual tests, browse through the [spec](https://github.com/monfresh/ohana-sms/tree/master/test) directory.

## Contributing

I'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/monfresh/ohana-api/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Copyright
Copyright (c) 2015 Moncef Belyamani. See [LICENSE](https://github.com/monfresh/ohana-sms/blob/master/LICENSE.md) for details.
