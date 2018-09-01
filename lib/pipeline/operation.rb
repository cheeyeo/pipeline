module Pipeline
  class Operation
    attr_reader :next_op, :data

    def initialize(next_op, data=nil)
      @next_op = next_op
      @data = data
    end

    def call(env)
      @next_op.call(env)
    end
  end

  class EmptyOperation < Operation
    def call(env)
      # NOOP
      env
    end
  end
end
