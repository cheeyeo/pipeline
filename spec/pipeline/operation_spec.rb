RSpec.describe Pipeline::Operation do
  describe 'initialize' do
    let(:next_op) { ->(x) { x + 1 } }
    let(:data) { 1 }
    let(:operation) do
      described_class.new(next_op, data)
    end

    it 'should be able to read the next operation' do
      expect(operation.next_op).to eq(next_op)
    end

    it 'should be able to read the data' do
      expect(operation.data).to eq(data)
    end

    it 'should invoke the next operation on call' do
      expect(operation.call(data)).to eq(2)
    end
  end

  describe 'empty operation' do
    let(:empty_operation) { Pipeline::EmptyOperation.new(nil) }

    it 'should inherit from Operation' do
      expect(empty_operation.class.superclass).to eq(described_class)
    end

    it 'should return the data on call' do
      expect(empty_operation.call(1)).to eq(1)
    end
  end
end
