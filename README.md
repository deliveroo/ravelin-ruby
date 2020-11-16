# Ravelin

[![Build Status](https://circleci.com/gh/deliveroo/ravelin-ruby.svg?style=svg)](https://circleci.com/gh/deliveroo/ravelin-ruby)

The Ravelin gem is a Ruby wrapper for the
[Ravelin API](https://developer.ravelin.com). Ravelin is a fraud detection
tool. See https://ravelin.com for more information.


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

First thing to do is create a client with your Ravelin API key.

```ruby
client = Ravelin::Client.new(api_key: 'sk_test_XXX')
```

### Proxy Client
An alternative client can be used to call Ravelin via an HTTP Proxy server that supports basic auth. 
* In order to use the alternative ProxyClient, you must have an HTTP Proxy running. 
* For the purpose of this example, we will use the url: `https://ravelin-proxy.com`.
* All requests to `https://ravelin-proxy.com/ravelinproxy` must have their basic auth header replaced with the Ravelin token in your HTTP proxy service, then forwarded the entire request to the Ravelin API.

Example of creating the proxy client:
```ruby
c = Ravelin::ProxyClient.new(base_url: 'https://ravelin-proxy.com', username:'foo', password:'bar')
```

### Configuration

The Ravelin gem uses [Faraday](https://github.com/lostisland/faraday) under the hood. The Faraday adapter and request
timeout can be configured with the following:

```ruby
require 'ravelin'
require 'net/http/persistent'

Ravelin.faraday_adapter = :net_http_persistent  # default is :net_http
Ravelin.faraday_timeout = 10                    # default is 1 second
```


### Send an event

Events require an event `name` and `payload` as named arguments. There is also an
optional `timestamp` argument if your event occurred at a different time. The score
argument will return a score for that User from Ravelin.

```ruby
client.send_event(
  name: :customer,
  timestamp: Time.now,
  score: true,
  payload: {
    # ...
  }
)
```


#### Event names

* `:customer`
* `:order`
* `:payment_method`
* `:pre_transaction`
* `:transaction`
* `:login`
* `:checkout`
* `:chargeback`
* `:voucher`
* `:voucher_redemption`

Information about the payload parameters for each event can be found in the
[Ravelin docs](https://developer.ravelin.com) (ravelins voucher & voucher_redemption docs not yet released) and by checking out the
`Ravelin::RavelinObject` classes in the gem
[source code](https://github.com/deliveroo/ravelin-ruby/tree/master/lib).

*Note:* The payload parameter names should use underscore formatting, not
camelcase formatting.


#### Event examples

```ruby
# Send a customer event

client.send_event(
  name: :customer,
  payload: {
    customer: {
      customer_id: 'cus_123',
      given_name:  'Joe',
      family_name: 'Fraudster',
      location: {
        street1:     '123 Street Lane',
        city:        'London',
        postal_code: 'SW1A 0AA',
        country:     'GBR'
      }
    }
  }
)

# Send an order event

client.send_event(
  name: :order,
  payload: {
    customer_id: 'cus_123',
    order: {
      order_id: 'ord_123',
      currency: 'GBP',
      price:    1000,
      from: {
        street1:     '123 Street Lane',
        postal_code: 'SW1A 0AA',
        country:     'GBR'
      },
      to: {
        street1:     '123 Street Lane',
        postal_code: 'SW1A 0AA',
        country:     'GBR'
      },
      items: [
        { sku: 'itm_1', quantity: 1 },
        { sku: 'itm_2', quantity: 1 }
      ]
    }
  }
)

# Send a voucher event

client.send_event(
  name: :voucher,
  payload: {
    voucher_code: 'TEST123',
    expiry: Time.now + 1,
    value: 500,
    currency: 'GBP',
    creation_time: Time.now,
    voucher_type: 'REFERRAL',
    referrer_id: '1',
    referral_value: 500
  }
)

# Send a voucher redemption event

client.send_event(
  name: :'paymentmethod/voucher',
  payload: {
    customer_id: 123983,
    voucher_redemption: {
      payment_method_id: 'voucher:12345',
      voucher_code: 'FOOBAR9835',
      referrer_id: '1',
      expiry: Time.now + 1,
      value: 500,
      currency: 'GBP,
      voucher_type: 'REFERRAL',
      redemption_time: Time.now - 1,
      success: false,
      failure_source: :CLIENT, 
      failure_reason: :EXPIRED
    }
  }
)

client.send_event(
  name: :'paymentmethod/voucher',
  payload: {
    customer_id: 123983,
    voucher_redemption: {
      payment_method_id: 'voucher:12345',
      voucher_code: 'FOOBAR9835',
      referrer_id: '1',
      expiry: Time.now + 1,
      value: 500,
      currency: 'GBP,
      voucher_type: 'REFERRAL',
      redemption_time: Time.now - 1,
      success: true,
    }
  }
)

```

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
