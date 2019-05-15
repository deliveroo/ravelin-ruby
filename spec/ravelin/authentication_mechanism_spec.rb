require 'spec_helper'

describe Ravelin::AuthenticationMechanism do
  subject do
    described_class.new(
      {
        password: {
          password: "lol",
          success: true
        }
      }
    )
  end

  context 'creates instance with valid params' do
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates a password object' do
    it { expect(subject.password.success).to eq(true) }
  end
end
