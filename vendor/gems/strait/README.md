# Strait

[![Coverage][shield-coverage]][coverage]
[![Maintainability][shield-maintainability]][maintainability]
[![Github Actions][shield-actions]][actions]
[![Rubygem Version][shield-version]][version]

[shield-coverage]: https://img.shields.io/codeclimate/coverage/hummingbird-me/strait.svg?logo=code-climate&style=for-the-badge
[coverage]: https://codeclimate.com/github/hummingbird-me/strait/progress/coverage
[shield-maintainability]: https://img.shields.io/codeclimate/maintainability/hummingbird-me/strait.svg?logo=code-climate&style=for-the-badge
[maintainability]: https://codeclimate.com/github/hummingbird-me/strait/progress/maintainability
[shield-actions]: https://img.shields.io/github/checks-status/hummingbird-me/strait/main?style=for-the-badge
[actions]: https://github.com/hummingbird-me/strait/actions
[shield-version]: https://img.shields.io/gem/v/strait?label=%20&logo=rubygems&logoColor=white&style=for-the-badge
[version]: https://rubygems.org/gems/strait

Strait is a rate-limiting library designed to provide security you don't need to think about. Whenever you have code to protect, put a Strait in front of it.

It strikes an excellent balance between accuracy and memory usage, with a default accuracy of 1/60th of the limit period.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strait'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strait

## Usage

Let's say you have a Rails controller with a lot of DoS attack potential.

```ruby
class SecureThingController
  def do_a_scare
    # Does some heavy work that could open it to a DoS attack!
  end
end
```

Well dang, that's no good. Anybody could send thousands of requests to this and take your entire site down, right as you're meeting with an important investor!

Let's put a Strait in front of it!

```ruby
class SecureThingController
  ScareLimiter = Strait.new('do_a_scare') do
    limit 5, per: 1.minute
  end

  rescue_from Strait::RateLimitExceeded do
    render :rate_limit_exceeded
  end

  def do_a_scare
    ScareLimiter.limit!(current_user)
    # Does heavy work, but only if the user hasn't exceeded their rate limit!
  end
end
```

Viola, just like that, we've got rate limiting. Now a user is limited to 5 per minute!

## Accuracy

To understand why Strait isn't perfectly accurate, we should understand how it's implemented. Strait is based on [the bucketed-log pattern made popular by Figma][figma-post], which chooses lower memory usage over perfect accuracy. Despite this decreased accuracy, it fails secure, and should have enough accuracy to not be noticed.

Each rate limiter stores data as a set of _N buckets per period_. For example, with 10 buckets and a 1-hour period, each bucket covers 6 minutes. To check the limit, we sum all buckets which overlap the last hour. If the buckets are large (like 6 minutes) this can be up to one bucket longer than the period, resulting in a longer block than 100% accuracy.

The default accuracy in Strait is _60 buckets per period_. For a 1-hour period, this is up to 1 minute of inaccuracy. For a 1-minute period, it's up to 1-second. For a 1-day period, it's up to 24 minutes. You can adjust this to increase accuracy, but it will also use more memory.

[figma-post]: https://www.figma.com/blog/an-alternative-approach-to-rate-limiting/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hummingbird-me/strait.

## License

The gem is available as open source under the terms of the [Apache-2.0 License](https://opensource.org/licenses/Apache-2.0).
