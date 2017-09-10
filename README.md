# NimbleThrottler

[![Code Climate](https://codeclimate.com/github/kimquy/nimble_throttler/badges/gpa.svg)](https://codeclimate.com/github/kimquy/nimble_throttler)

[![Build Status](https://travis-ci.org/kimquy/nimble_throttler.svg?branch=master)](https://travis-ci.org/kimquy/nimble_throttler)

NimbleThrottler is very simple ruby gem which allow throttling an certain endpoints.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nimble_throttler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nimble_throttler

## Usage

Add the following code into `application.rb` of your Rails app.

```ruby
require "nimble_throttler"

module YourRailsApp
  class Application < Rails::Application
    config.middleware.use Rack::NimbleThrottling
  end
end
```

Now you're ready to throttle the endpoints by adding this file `nimble_throttling.rb` into `initializers` folder. Example:

```ruby
NimbleThrottler.configure do
  throttle '/testing', limit: 5, period: 1.hours
  throttle '/awesome', limit: 100, period: 2.hours
  throttle '/home/page', limit: 100, period: 3.hours
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kimquy/nimble_throttler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
