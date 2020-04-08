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
      it 'throws ArgumentError with no customer_id or temp_customer_id' do
        expect {
          described_class.new(name: :order, payload: {})
        }.to raise_exception(
          ArgumentError,
          /payload missing customer_id or temp_customer_id/
        )
      end

      it 'accepts customer_id' do
        expect {
          described_class.new(name: :order, payload: { customer_id: 1 })
        }.to_not raise_exception
      end

      it 'accepts temp_customer_id' do
        expect {
          described_class.new(name: :order, payload: { temp_customer_id: 2 })
        }.to_not raise_exception
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

    context '3ds support' do
      let(:event) { described_class.new(name: :transaction, payload: payload) }
      let(:timestamp) { Time.now.to_i }
      let(:three_d_secure) do
        {
          attempted:  true,
          success:    true,
          start_time: timestamp,
          end_time:   timestamp
        }
      end
      let(:payload) do
        {
          customer_id: 123,
          payment_method_id: 123,
          order_id: 123,
          transaction: {
            transaction_id: 123,
            currency: 'GBP',
            debit: 100,
            credit: 0,
            gateway: 'stripe',
            gateway_reference: 123,
            success: true,
            '3ds' => three_d_secure
          }
        }
      end

      it '3ds is included in the output' do
        serialized_transaction = event.serializable_hash['transaction']
        serialized_three_d_secure = {
          '3ds' =>  {
            'attempted' => true,
            'success'   => true,
            'startTime' => timestamp,
            'endTime'   => timestamp,
            'timedOut'  => false
          }
        }
        expect(serialized_transaction).to include(serialized_three_d_secure)
      end
    end

    context 'required mutually exclusive params' do
      let(:payload) do
        {
          customer_id: 123,
          payment_method_id: 123,
          payment_method: {
            payment_method_id: 123,
            method_type: 'card'
          },
          order_id: 321
        }
      end

      it 'throws ArgumentError when both are present' do
        expect {
          described_class.new(name: :transaction, payload: payload)
        }.to raise_exception(
          ArgumentError,
          /parameters are mutally exclusive: payment_method_id, payment_method/
        )
      end

      it 'throws ArgumentError when neither are present' do
        payload_modified = payload.dup.tap do |p|
          p.delete(:payment_method_id)
          p.delete(:payment_method)
        end

        expect {
          described_class.new(name: :transaction, payload: payload_modified)
        }.to raise_exception(
          ArgumentError,
          /payload must include one of: payment_method_id, payment_method/
        )
      end

      it 'is valid when one of the mutally exclusive keys is present' do
        [:payment_method, :payment_method_id].each do |key_to_remove|
          payload.dup.tap do |p|
            p.delete(key_to_remove)

            expect {
              described_class.new(name: :transaction, payload: p)
            }.not_to raise_exception
          end
        end

      end
    end

    context 'v2 login event' do
      let(:payload) {
        {
          username: "big.jim@deliveroo.invalid",
          customer_id: 123,
          success: true,
          authentication_mechanism: {
            password: {
              password: "lol",
              success: true
            }
          }
        }
      }

      it 'throws ArgumentError with missing payload parameters' do
        expect {
          described_class.new(
              name: :login,
              payload: { }
          )
        }.to raise_exception(
                 ArgumentError,
                 /payload missing parameters: username, success, authentication_mechanism/
        )
      end

      it 'is executed cleanly with required payload parameters' do
        expect {
          described_class.new(
            name: :login,
            payload: payload
          )
        }.to_not raise_exception
      end

      it 'it generates the correct serializable hash' do
        output = described_class.new(
            name: :login,
            payload: payload,
            timestamp: 1586283630
        ).serializable_hash

        expect(output).to eq(
          {
            "authenticationMechanism" => {
              "password" => {
                "passwordHashed" => "07123e1f482356c415f684407a3b8723e10b2cbbc0b8fcd6282c49d37c9c1abc",
                "success" => true
              }
            },
            "customerId" => "123",
            "success" => true,
            "username" => "big.jim@deliveroo.invalid",
            "timestamp" => 1586283630
          }
        )
      end

      it 'includes the correct event name' do
        expect(
          described_class.new(
            name: :login,
            payload: payload
          ).name).to eq(:login)
      end

    end

    context 'v3 login event' do
      let(:payload) {
        {
          login: {
            username: "big.jim@deliveroo.invalid",
            customer_id: 123,
            success: true,
            authentication_mechanism: {
              password: {
                password: "lol",
                success: true
              }
            }
          }
        }
      }

      it 'throws ArgumentError with missing payload parameters' do
        expect {
          described_class.new(
            name: :ato_login,
            payload: { }
          )
        }.to raise_exception(
                 ArgumentError,
                 /payload missing parameters: login/
             )
      end

      it 'is executed cleanly with required payload parameters' do
        expect {
          described_class.new(
            name: :ato_login,
            payload: payload
          )
        }.to_not raise_exception
      end

      it 'it generates the correct serializable hash' do
        output = described_class.new(
          name: :ato_login,
          payload: payload,
          timestamp: 1586283630
        ).serializable_hash

        expect(output).to eq(
          {
            "login" => {
              "authenticationMechanism" => {
                "password" => {
                  "passwordHashed" => "07123e1f482356c415f684407a3b8723e10b2cbbc0b8fcd6282c49d37c9c1abc",
                  "success" => true
                }
              },
              "customerId" => "123",
              "success" => true,
              "username" => "big.jim@deliveroo.invalid"
            },
            "timestamp" => 1586283630000
          }
        )
      end

      it 'includes the correct event name' do
        expect(
          described_class.new(
            name: :ato_login,
            payload: payload
          ).name).to eq(:login)
      end
    end

    context 'account reclamation' do
      it 'throws ArgumentError with missing payload parameters' do
        expect {
          described_class.new(name: :ato_reclaim, payload: {})
        }.to raise_exception(
                 ArgumentError,
                 /payload missing parameters: customers/
             )
      end

      it 'is executed cleanly with required payload parameters' do
        expect {
          described_class.new(
            name: :ato_reclaim,
            payload: { customers: [{customer_id: "12345", method: "PasswordReset"}], source: "ATO" },
          )
        }.to_not raise_exception
      end

      it 'it generates the correct serializable hash' do
        output = described_class.new(name: :ato_reclaim,
                                     payload: { customers: [{customer_id: "12345", method: "PasswordReset"}], source: "ATO" },
                                     timestamp: 1586283630)
                     .serializable_hash
        expect(output).to eq( {"customers"=>[{:customer_id=>"12345", :method=>"PasswordReset"}], "source"=>"ATO", "timestamp"=>"2020-04-07T18:20:30+00:00"} )
      end

      it 'includes the correct event name' do
        expect(
          described_class.new(
            name: :ato_reclaim,
            payload: { customers: [{customer_id: "12345", method: "PasswordReset"}], source: "ATO" }
          ).name).to eq(:reclaim)
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
