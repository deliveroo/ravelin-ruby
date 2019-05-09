require 'spec_helper'

describe Ravelin::Login do
  subject do
    described_class.new(
      {
        "username": "big.jim@deliveroo.invalid",
        "customer_id": 123,
        "success": true,
        "authentication_mechanism": {
          "password": {
            "password": "lol",
            "success": true
          }
        }
      }
    )
  end

  context 'creates instance with valid params' do
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates an authentication_mechanism object' do
    it { expect(subject.authentication_mechanism.password.success).to eq(true) }
  end
end
