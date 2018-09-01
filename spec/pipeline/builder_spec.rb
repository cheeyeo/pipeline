RSpec.describe Pipeline::Builder do
  describe '#initialization' do
    context 'with a block parameter' do
      it 'should yield to the block' do
        builder = nil

        pipeline = described_class.new { |b| builder = b }

        expect(builder).to_not be_nil
        expect(builder).to be_instance_of(Pipeline::Builder)
      end
    end

    context 'without a block parameter' do
      it 'should act in the builder\'s context' do
        Pipeline::Builder.class_eval do
          def log
            'A log message'
          end
        end

        msg = ''
        described_class.new { msg = log }
        expect(msg).to eq('A log message')
      end
    end
  end

  describe '#inspect_stack' do
    context 'reading the operation stack' do
      it 'should not allow modifying it' do
        builder = Pipeline::Builder.new

        expect do
          builder.inspect_stack << 1
        end.to raise_error(FrozenError)
      end
    end
  end

  describe '#use' do
    context 'adding an operation' do
      it 'should push it onto the stack' do
        example_op = ->(x) { x + 1 }

        builder = Pipeline::Builder.new do
          use example_op, 9
        end

        expect(builder.inspect_stack).to include([example_op, [9], nil])

        expect do
          builder.inspect_stack << 1
        end.to raise_error(FrozenError)
      end
    end
  end

  describe '#call' do
    context 'without any operations' do
      it 'should return a result' do
        builder = Pipeline::Builder.new

        res = builder.call(9)
        expect(res).to eq(9)
      end
    end

    context 'with operation procs' do
      it 'should return a result' do
        builder = Pipeline::Builder.new do
          use -> (x) { x + 1 }
        end

        res = builder.call(9)

        expect(res).to eq(10)
      end
    end

    context 'with operation classes' do
      before do
        class AddOne
          def initialize(next_op)
            @next_op = next_op
          end

          def call(env)
            env += 1
            @next_op.call(env)
          end
        end
      end

      it 'should return a result' do
        builder = Pipeline::Builder.new do
          use AddOne
        end

        res = builder.call(9)

        expect(res).to eq(10)
      end
    end
  end
end
