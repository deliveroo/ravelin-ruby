require 'spec_helper'

describe Ravelin::AuthenticationMechanisms::MagicLink do
  context 'creates instance with valid params and no failure' do
    subject { described_class.new(transport: 'email', email: 'joe@example.com', success: true) }
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates instance with valid params and failure' do
    subject { described_class.new(transport: 'email', email: 'joe@example.com', success: false, failure_reason: 'INVALID_LINK') }
    it { expect { subject }.to_not raise_exception }
  end

  context 'fails if required success param is not provided' do
    subject { described_class.new(transport: 'email', phone_number: '+447123456789', failure_reason: 'INVALID_LINK') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/missing parameters: success/) }
  end

  context 'fails if required transport param is not provided' do
    subject { described_class.new(phone_number: '+447123456789', success: false, failure_reason: 'INVALID_LINK') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/missing parameters: transport/) }
  end

  context 'fails if transport param is sms but phone_number is not provided' do
    subject { described_class.new(transport: 'sms', email: 'joe@example.com', success: false, failure_reason: 'INVALID_LINK') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/phone_number must be present for sms transportation mechanism/) }
  end

  context 'fails if transport param is eamil but email is not provided' do
    subject { described_class.new(transport: 'email', success: false, failure_reason: 'INVALID_LINK') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/email must be present for email transportation mechanism/) }
  end

  context 'fails if the result is failure and no failure reason is provided' do
    subject { described_class.new(transport: 'email', email: 'joe@example.com', success: false) }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/) }
  end

  context 'fails if the failure reason is not in the list of accepted reasons' do
    subject { described_class.new(transport: 'email', email: 'joe@example.com', success: false, failure_reason: 'bogus') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/) }
  end

  context 'fails if the transport is not in the list of accepted reasons' do
    subject { described_class.new(transport: 'foo', phone_number: '+447123456789', success: true) }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Transportation mechanism value must be one of/) }
  end

end
