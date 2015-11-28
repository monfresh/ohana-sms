# Ohana SMS

[![Build Status](https://travis-ci.org/monfresh/ohana-sms.png?branch=master)](https://travis-ci.org/monfresh/ohana-sms) [![Code Climate](https://codeclimate.com/github/monfresh/ohana-sms/badges/gpa.svg)](https://codeclimate.com/github/monfresh/ohana-sms) [![Dependency Status](https://gemnasium.com/monfresh/ohana-sms.svg)](https://gemnasium.com/monfresh/ohana-sms) [![Test Coverage](https://codeclimate.com/github/monfresh/ohana-sms/badges/coverage.svg)](https://codeclimate.com/github/monfresh/ohana-sms)

Ohana SMS is a Ruby on Rails application that allows people in need who lack
access to the internet to find human services via SMS.

By default, Ohana SMS is able to query any [Ohana API][ohana-api] instance,
but it can be modified to work with any API.

[ohana-api]: https://github.com/codeforamerica/ohana-api

## Stack Overview

* Ruby version 2.2.3
* Rails version 4.2.5
* Testing Frameworks: MiniTest

## Local Installation

### Prerequisites
You'll need a Ruby development environment on your computer, and a Twilio account.

#### Ruby
If you're on a Mac, the easiest way to get up and running is to run my
[laptop script](https://github.com/monfresh/laptop). On Linux, you'll need to
install [Build tools][build-tools], [Ruby with RVM][ruby], and [Node.js][node].

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
3. Copy your AuthToken and paste it in `config/application.yml`
next to `twilio_auth_token`.

[settings]: https://www.twilio.com/user/account/settings

## Deploy to Heroku

1. Click this button: [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

2. Sign in, or sign up if you don't already have a Heroku account

3. Fill in the `App Name` field with your desired name, such as `ohana-sms-demo`

4. Scroll down and click `Deploy for Free`

5. Once your app is created, go to your computer's command line
and run `figaro heroku:set -e production -a your_app_name`,
where `your_app_name` is the name you chose in step 3.
This will configure your Heroku app with your secret Twilio information
from your `application.yml`.

6. Go to the Twilio [Manage Numbers][manage] page and click on your number.

7. Under `Messaging`, in `Request URL`, enter
`https://ohana-sms-demo.herokuapp.com/locations/reply`, making sure to
replace `ohana-sms-demo` with your actual Heroku app name. Then select
`HTTP GET` from the dropdown, and click `Save`. It should look like this:

![Twilio Messaging Request URL](http://cl.ly/image/061w3F2H0W0X/download/Image%202015-03-03%20at%2011.51.27%20PM.png)

[manage]: https://www.twilio.com/user/account/phone-numbers/incoming

## Test the app with your phone

1. Send an SMS to your Twilio number. You should be asked to enter a ZIP code:
   ```
   Hi! Please enter a 5-digit ZIP code to get started.
   ```

2. Send `94025`. You should be offered to choose a category:
   ```
   Please choose a category by entering its number: #1: Care,
   #2: Education...
   ```

3. Send `1`. You should get up to 5 results if there's a match:
   ```
   Here are up to 5 locations that match your search.
   To get more details about a location, enter its number.
   #1: Rosener House Adult Day Services (Peninsula Volunteers)...
   ```
   If there isn't a match, you should get:
   ```
   Sorry, no results found. Please try again with a different ZIP code or category.
   ```

4. Send `1`. You should get more details about Rosener House
(short description, phone, and address).

5. You can now send a different result number to see details about another location.

6. To reset the conversation, send `reset` (it's not case-sensitive).

## Configure the app to return your own data
If you haven't already deployed an instance of [Ohana API][ohana-api] with
your own data, you'll need to do that first.

Then, all you'll need to do is set the `OHANA_API_ENDPOINT` config var on
Heroku to your API's URL:

```
heroku config:set OHANA_API_ENDPOINT=https://your_ohana_api_url -a your_heroku_app_name
```

[ohana-api]: https://github.com/codeforamerica/ohana-api

## Customizing and translating the SMS messages

Currently, what can be translated are the greetings and instructions.
The search results content, such as the Location names, or the short
descriptions, are not translated. In order to translate search results,
you would need to sign up for Google's paid translation service, but I
have not integrated it in this app yet.

To translate the greetings and instructions, copy and paste the contents of
`config/locales/en.yml` into a new file in `config/locales` with a filename
corresponding to the language's two-character code, and with a `.yml`
extension. Then translate the text from English into your desired language.
See `config/locales/es.yml` as an example. For more details, read the
[Rails Internationalization Guide](http://guides.rubyonrails.org/i18n.html).

Once your translations are in place, create a new number in your Twilio account
that will be used for a particular language. Following the same instructions
as in Step 7 in the [Deploy to Heroku section](#deploy-to-heroku), add `?locale=[language_code]` to
the end of the Request URL. For example, to make your phone number use the
Spanish version of the app, your Request URL would look like this:
```
https://ohana-sms-demo.herokuapp.com/locations/reply?locale=es
```

## Running the tests

Run tests locally with this command:

    script/test

To see the actual tests, browse through the [test] directory.

[test]: https://github.com/monfresh/ohana-sms/tree/master/test

Credits
-------

Created by [Moncef Belyamani](https://twitter.com/monfresh).

Inspired by and built upon the work of
[Mark Silverberg](https://github.com/marks/ohana-sms).

### Public domain

This project is [dedicated to the public domain](LICENSE.md).
As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright
> and related rights in the work worldwide are waived through the
> [CC0 1.0 Universal public domain dedication][CC0].
>
> All contributions to this project will be released under the CC0 dedication.
> By submitting a pull request, you are agreeing to comply with this waiver of
> copyright interest.

[CC0]: https://creativecommons.org/publicdomain/zero/1.0/