# Simpal

A simple, lightweight wrapper around PayPal's REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simpal'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simpal

## Usage

First, create a client ID and secret from the [Applications](https://developer.paypal.com/developer/applications) page
of your PayPal account dashboard.

Then, create a client which uses these credentials:

```ruby
Simpal.client = Simpal::Client.new(
  client_id: 'CLIENT_ID',
  client_secret: 'CLIENT_SECRET',
  sandbox: true
)
```

The value of **Simpal.client** is to make requests, unless the **client** attribute is specified on a per-request basis.
The **sandbox** attribute defaults to **false** if omitted.

Once the client has been setup, it's easy to retrieve an order:

```ruby
Simpal::Order.retrieve('ORDER_ID')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nialtoservices/simpal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nialtoservices/simpal/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).

## Code of Conduct

Everyone interacting in the Simpal project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/simpal/blob/main/CODE_OF_CONDUCT.md).
