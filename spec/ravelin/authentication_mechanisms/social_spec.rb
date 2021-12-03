require 'spec_helper'

describe Ravelin::AuthenticationMechanisms::Social do
  subject {
    described_class.new(
      social_provider: 'google',
      success: true,
    )
  }

  context 'creates instance with valid params and no failure' do
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates instance with valid params and failure' do
    subject { described_class.new(social_provider: 'google', success: false, failure_reason: 'UNKNOWN_USERNAME') }
    it { expect { subject }.to_not raise_exception }
  end

  context 'fails if the result is failure and no failure reason is provided' do
    subject { described_class.new(social_provider: 'google', success: false) }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/)}
  end

  context 'fails if the failure reason is not in the list of accepted reasons' do
    subject { described_class.new(social_provider: 'google', success: false, failure_reason: 'bogus') }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Failure reason value must be one of/)}
  end

  context 'fails if the social provider is not in the list of accepted providers' do
    subject { described_class.new(social_provider: 'bogus', success: true) }
    it { expect { subject }.to raise_error(ArgumentError).with_message(/Social provider value must be one of/)}
  end
end
