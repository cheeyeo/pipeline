module Pipeline
  class Builder
    def initialize(&block)
      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval(&block)
        end
      end
    end

    # Adds an operation to the internal stack
    # @param [Class] operation - The operation class
    # @param [Array] args - Arguments for the operation
    # @param [Proc] block - Optional block for the operation
    def use(operation, *args, &block)
      stack << [operation, args, block]
      self
    end

    # Calls the operations in the stack
    # @param [Object] env - Optional initial input to the pipeline
    def call(env)
      build_operation_chain(stack.dup).
        call(env.dup)
    end

    # Returns the internal stack array for reading as a frozen object
    def inspect_stack
      stack.freeze
    end

    private

    def stack
      @stack ||= []
    end

    # Iterate through the stack and build a single
    # callable object which consists of each operation
    # referencing the next one in the chain
    def build_operation_chain(stack)
      empty_op = EmptyOperation.new(nil)

      stack.reverse.reduce(empty_op) do |next_op, current_op|
        klass, args, block = current_op

        if Class === klass
          klass.new(next_op, *args, &block)
        elsif Proc === klass
          lambda do |env|
            next_op.call(klass.call(env, *args))
          end
        else
          raise StandardError, "Invalid operation, doesn't respond to `call`: #{klass.inspect}"
        end
      end
    end
  end
end
