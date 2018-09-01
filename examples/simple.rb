require "pipeline"

class HelloWorld < Pipeline::Operation
  def call(env)
    # env is the data passed in from the pipeline
    # do your data processing here ...

    env = "Hello, #{env}"

    super
  end
end

res = Pipeline::Builder.new do |b|
        b.use HelloWorld
        b.use ->(str) { "More processing: #{str}" }
      end.call('World')

puts res
