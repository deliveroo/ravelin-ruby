# Ravelin

<<<<<<< HEAD
The Ravelin gem is a Ruby wrapper for the
(Ravelin API)[https://developer.ravelin.com]. Ravelin is a fraud detection
tool. See https://ravelin.com for more information.
=======
[![Build Status](https://travis-ci.org/deliveroo/ravelin-ruby.svg?branch=master)](https://travis-ci.org/deliveroo/ravelin-ruby)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ravelin`. To experiment with that code, run `bin/console` for an interactive prompt.
>>>>>>> master


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ravelin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ravelin

## Usage

### Authentication

First think to do is create a client with your Ravelin API key.

```ruby
client = Ravelin::Client.new(api_key: 'sk_test_XXX')
```


### Send an event

Events require an event `name` and `payload` as arguments. There is also an
optional `timestamp` argument if your event occurred at a different time.

```ruby
client.send_event(
  name: :customer,
  timestamp: Time.now,
  payload: {
    # ...
  }
)
```

#### Event names

* `:customer`
* `:order`
* `:items`
* `:payment_method`
* `:pre_transaction`
* `:transaction`
* `:login`
* `:checkout`
* `:chargeback`

Information about the payload parameters for each event can be found in the
(Ravelin docs)[https://developer.ravelin.com] and by checking out the
`Ravelin::RavelinObject` classes in the gem
(source code)[https://github.com/deliveroo/ravelin-ruby/tree/master/lib].

*Note:* The payload parameter names should use underscore formatting, not
camelcase formatting.


### Send a backfill event

Backfill events are designed to be used to populate Ravelin with historical
data. The Ravelin backfill event API is identical to the regular event API,
other than that the backfill event API is not subject to the standard rate
limits.

See https://developer.ravelin.com/#backfill for more information.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/deliveroo/ravelin. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

