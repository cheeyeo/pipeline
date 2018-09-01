# Pipeline

Pipeline is a gem that enables you to build `operations` to transform data from one state to another using `pipelines`

This is based on the [chain-of-responsibility pattern](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data-pipeline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data-pipeline

## Usage

Load the pipeline gem into your project:
```ruby
require 'pipeline'
```

Before we can create a pipeline, we need operation objects for processing the data.

Start by creating a simple `Operation` object by inheriting from `Pipeline::Operation` class:

```ruby
class HelloWorld < Pipeline::Operation
  def call(env)
    # env is the data passed in from the pipeline
    # do your data processing here ...

    "Hello, #{env}"

    super
  end
end
```

The example `HelloWorld` operation appends `'Hello'` to every string passed in.

Next, we need to create a `pipeline`. Within a pipeline, we can chain multiple operations to transform the data into the desired state.

Suppose we create a `HelloWorld` pipeline to use the `HelloWorld` operation, we can do it as follows:

```ruby
  Pipeline::Builder.new do |b|
    b.use HelloWorld
  end.call('World')
```

The above will return `'Hello World'`

We can also add operation classes as procs. From the above example, we can wrap the string in another by using an additional proc:

```ruby
Pipeline::Builder.new do |b|
  b.use HelloWorld
  b.use ->(str) { "More processing: #{str}" }
end.call('World')
```

The above will return `'More processing: Hello World'`

We can also pass additional data into the operation classes:

```ruby
  Pipeline::Builder.new do |b|
    b.use HelloWorld, 'Additional args'
  end.call('World')
```
Within the operation class we can access it using the `data` attribute.

```ruby
class HelloWorld < Pipeline::Operation
  def call(env)
    # env is the data passed in from the pipeline
    # data is passed in to the operation #=> 'Additional args'
    # ....
    super
  end
end
```

## Using custom operation classes

Operation classes have a very simple interface.

To create your own operation classes, you need to implement the following methods:

```ruby
  initialize(next_op, data=nil)

  call(env)
```

`initialize` takes 2 arguments: the next operation to call; and any optional data the operation accepts

`call` performs the processing on the passed in data from the builder e.g. `builder.call(mydata)`

An example custom operation class:
```ruby
  class CustomOp
    attr_reader :next_op, :data

    def initialize(next_op, data=nil)
      @next_op = next_op
      @data = data
    end

    def call(env)
      # Data processing here...
      @next_op.call(env)
    end
  end
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
