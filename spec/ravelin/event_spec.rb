require 'spec_helper'

class MyDummyClass < Ravelin::RavelinObject
  attr_accessor :name
end

describe Ravelin::Event do
  let(:event) { described_class.new(name: :ping, payload: {}) }

  describe '#to_hash' do
    let(:dummy) { MyDummyClass.new(name: 'Fraudster') }

    before { allow(event).to receive(:payload).and_return(payload) }

    context 'payload with non Ravelin objects' do
      let(:payload) { { name: 'John', timestamp: 123456789 } }

      it 'left as they are' do
        expect(event.to_hash).to eq({ name: 'John', timestamp: 123456789 })
      end
    end

    context 'payload with mixed objects' do
      let(:payload) { { timestamp: 12345, dummy: dummy } }

      it 'converts the Ravelin objects to hash' do
        expect(event.to_hash).to eq({
          timestamp: 12345,
          dummy: { 'name' => 'Fraudster' }
        })
      end
    end
  end

  describe '#convert_to_ravelin_objects' do
    let(:event) { described_class.new(name: :ping, payload: payload) }

    before do
      allow(Ravelin::Event).to receive(:object_classes).
        and_return({ dummy: MyDummyClass })
    end

    context 'when key found in #object_classes' do
      let(:payload) { { dummy: { name: 'Fraudster' } } }

      it 'converts payload values to Ravelin objects' do
        expect(event.payload).to include({ dummy: instance_of(MyDummyClass) })
      end
    end

    context 'when key not in #object_classes' do
      let(:payload) { { timestamp: 12345 } }

      it 'leaves payload values alone' do
        expect(event.payload).to eq({ timestamp: 12345 })
      end
    end
  end
end
