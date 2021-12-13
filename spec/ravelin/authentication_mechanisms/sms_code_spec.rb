require 'spec_helper'

describe Ravelin::AuthenticationMechanisms::SmsCode do
  context 'creates instance with valid params and no failure' do
    subject { described_class.new(phone_number: '+447123456789', success: true) }
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates instance with valid params and failure' do
    subject { described_class.new(phone_number: '+447123456789', success: false, failure_reason: 'INVALID_CODE') }
    it { expect { subject }.to_not raise_exception }
  end

  context 'fails if the result is failure and no failure reason is provided' do
    subject { described_class.new(phone_number: '+447123456789', success: false) }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/)}
  end

  context 'fails if the failure reason is not in the list of accepted reasons' do
    subject { described_class.new(phone_number: '+447123456789', success: false, failure_reason: 'bogus') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/)}
  end
end
