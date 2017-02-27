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
        expect(event.serializable_hash).to eq({
            'name' => 'John',
            'timestamp' => 12345
          })
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
  end

  describe '#validate_top_level_payload_params' do
    context 'customer presence required' do
      [:login, :order, :paymentmethod].each do |event|
        it "throws ArgumentError with no customer_id or temp_customer_id for #{event}" do
          expect {
            described_class.new(name: event, payload: {})
          }.to raise_exception(
            ArgumentError,
            /payload missing customer_id or temp_customer_id/
          )
        end

        it "accepts customer_id for #{event}" do
          expect {
            described_class.new(name: event, payload: { customer_id: 1 })
          }.to_not raise_exception
        end

        it "accepts temp_customer_id for #{event}" do
          expect {
            described_class.new(name: event, payload: { temp_customer_id: 2 })
          }.to_not raise_exception
        end
      end
    end

    context 'payload parameters required' do
      it 'throws ArgumentError with missing payload parameters' do
        expect {
          described_class.new(name: :customer, payload: {})
        }.to raise_exception(
          ArgumentError,
          /payload missing parameters: customer/
        )
      end

      it 'is executed cleanly with required payload parameters' do
        expect {
          described_class.new(
            name: :customer,
            payload: { customer: { customer_id: 123 } }
          )
        }.to_not raise_exception
      end
    end
  end

  describe '#convert_to_epoch' do
    let(:event) do
      described_class.new(name: :ping, payload: {}, timestamp: timestamp)
    end

    context 'Time argument' do
      let(:timestamp) { Time.now }

      it 'returns an epoch Integer' do
        expect(event.timestamp).to be_an(Integer)
      end
    end

    context 'DateTime argument responding to #to_i' do
      let(:timestamp) { DateTime.now }

      # Simulate Rails DateTime objects
      before { allow(timestamp).to receive(:to_i) { Time.now.to_i } }

      it 'returns an epoch Integer' do
        expect(event.timestamp).to be_an(Integer)
      end
    end

    context 'Integer' do
      let(:timestamp) { Time.now.to_i }

      it 'returns an epoch Integer' do
        expect(event.timestamp).to be_an(Integer)
      end
    end

    context 'String' do
      let(:timestamp) { '2015-10-10' }

      it 'raises a TypeError exception' do
        expect { event.timestamp }.to raise_exception(
          TypeError,
          /timestamp requires a Time or epoch Integer/
        )
      end
    end
  end

  describe '#convert_to_ravelin_objects' do
    let(:event) do
      described_class.new(name: :ping, timestamp: 12345, payload: payload)
    end

    before do
      allow_any_instance_of(Ravelin::Event).to receive(:object_classes).
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

    context 'when an _id field is present' do
      let(:payload) { { customer_id: 123 } }

      it "converts integer attributes suffixed with _id to strings" do
        expect(event.payload).to eq({ customer_id: '123' })
      end
    end
  end
end
