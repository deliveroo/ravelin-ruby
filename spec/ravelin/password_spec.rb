require 'spec_helper'

describe Ravelin::Password do
  subject {
    described_class.new(
      password: 'qwerty123',
      success: true,
    )
  }
  let(:expected_hash) { 'daaad6e5604e8e17bd9f108d91e26afe6281dac8fda0091040a7a6d7bd9b43b5' }

  context 'creates instance with valid params and no failure' do
    it { expect { subject }.to_not raise_exception }
  end

  context 'hashes supplied password parameter' do
    it { expect(subject.password_hashed).to eq(expected_hash) }
  end

  context 'creates instance with valid params and failure' do
    subject { described_class.new(password: 'qwerty123', success: false, failure_reason: 'BAD_PASSWORD') }
    it { expect { subject }.to_not raise_exception }
  end

  context 'fails if the failure reason is not in the list of accepted reasons' do
    subject { described_class.new(password: 'qwerty123', success: false, failure_reason: 'lol') }
    it { expect { subject }.to raise_error(ArgumentError) }
  end
end
