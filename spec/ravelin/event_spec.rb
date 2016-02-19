require 'spec_helper'

class MyDummyClass < Ravelin::RavelinObject
  attr_accessor :name
end

describe Ravelin::Event do
  let(:event) do
    described_class.new(name: :ping, timestamp: 12345, payload: {})
  end

  describe '#serializable_hash' do
    let(:dummy) { MyDummyClass.new(name: 'Fraudster') }

    before { allow(event).to receive(:payload).and_return(payload) }

    context 'payload with non Ravelin objects' do
      let(:payload) { { name: 'John' } }

      it 'left as they are' do
        expect(event.serializable_hash).to eq({ 'name' => 'John', 'timestamp' => 12345 })
      end
    end

    context 'payload with Ravelin objects' do
      let(:payload) { { dummy: dummy } }

      it 'converts the Ravelin objects to hash with camelcase keys' do
        expect(event.serializable_hash).to eq({
          'timestamp' => 12345,
          'dummy' => { 'name' => 'Fraudster' }
        })
      end
    end

    context 'payload with lists of Ravelin objects' do
      let(:payload) { { things: [dummy, dummy] } }

      it 'converts the list of Ravelin objects to hashes with camelcase keys' do
        expect(event.serializable_hash).to eq({
          'timestamp' => 12345,
          'things' => [
            { 'name' => 'Fraudster' },
            { 'name' => 'Fraudster' }
          ]
        })
      end
    end
  end

  describe '#validate_top_level_payload_params' do
    context 'customer presence required' do
      pending
    end

    context 'payload parameters required' do
      pending
    end
  end

  describe '#convert_to_epoch' do
    pending
  end

  describe '#convert_to_ravelin_objects' do
    let(:event) do
      described_class.new(name: :ping, timestamp: 12345, payload: payload)
    end

    before do
      allow(Ravelin::Event).to receive(:object_classes).
        and_return({ dummy: MyDummyClass })
      allow(Ravelin::Event).to receive(:list_object_classes).
        and_return({ things: MyDummyClass })
    end

    context 'when key found in .object_classes' do
      let(:payload) { { dummy: { name: 'Fraudster' } } }

      it 'converts payload values to Ravelin objects' do
        expect(event.payload).to include({ dummy: instance_of(MyDummyClass) })
      end
    end

    context 'when key found in .list_object_classes' do
      let(:payload) { { things: [ { name: 'dummy-1' }, { name: 'dummy-2' }] } }

      it 'converts payload list values to Ravelin objects' do
        expect(event.payload).to include({
          things: [instance_of(MyDummyClass), instance_of(MyDummyClass)]
        })
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
