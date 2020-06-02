# DeadMansSnitchApi

A wrapper around the API for [Dead Man's Snitch](https://deadmanssnitch.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dead_mans_snitch_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dead_mans_snitch_api

## Usage

First, set your API key, found in the DMS dashboard under "Keys":

```ruby
DeadMansSnitchApi.config.api_key = "API_KEY"
```

### List all snitches

Optionally pass an array of tags to filter by

```ruby
DeadMansSnitchApi.all_snitches(tags: ["some", "tags"]) # => Array<DeadMansSnitchApi::Snitch>
```

### Create a snitch

```ruby
attributes = {
  name: "Backup", # A string
  alert_type: "basic", # either basic or smart
  interval: "hourly", # One of 30_minutes, hourly, daily
  tags: ["production", "backups"], # Optional: an array of tags
  alert_email: ["foo@example.com"], # Optional: an array of emails to notify
  notes: "This is important", # Optional: a string detailing the snitch
}

DeadMansSnitch.create(attributes: attributes) # => DeadMansSnitchApi::Snitch
```

### Update a snitch

```ruby
attributes = {
  name: "Backup", # A string
  alert_type: "basic", # either basic or smart
  interval: "hourly", # One of 30_minutes, hourly, daily
  tags: ["production", "backups"], # Optional: an array of tags
  alert_email: ["foo@example.com"], # Optional: an array of emails to notify
  notes: "This is important", # Optional: a string detailing the snitch
}

DeadMansSnitch.update(token: "123", attributes: attributes) # => DeadMansSnitchApi::Snitch
```

### Pause a snitch

```ruby
DeadMansSnitch.pause(token: "123") # true
```

### Delete a snitch

```ruby
DeadMansSnitch.delete(token: "123") # true
```

### Notify DMS

```ruby
DeadMansSnitch.notify(token: "123") # true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dead_mans_snitch_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dead_mans_snitch_api/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeadMansSnitchApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dead_mans_snitch_api/blob/master/CODE_OF_CONDUCT.md).
