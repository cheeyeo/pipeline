# Pipeline

Pipeline is a gem that enables you to build `operations` to transform data from one state to another using `pipelines`

This is based on the [chain-of-responsibility pattern](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipeline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipeline

## Usage

Load the pipeline gem into your project:
```ruby
require 'pipeline'
```

Start by creating an `Operation` object by inheriting from `Pipeline::Operation` class:

```ruby
class HelloWorld < Operation
  def call(env)
    # env is the data passed in from the pipeline

    "Hello, #{env}"
  end
end
```

The example `HelloWorld` operation appends 'Hello' to every string passed in.

To use operations, we need to create a pipeline.

Suppose we create a `HelloWorld` pipeline, we can do it as follows:

```ruby
  Pipeline::Builder.new do |b|
    b.use HelloWorld
  end.call('World')
```







## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cheeyeo/pipeline. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pipeline project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pipeline/blob/master/CODE_OF_CONDUCT.md).
