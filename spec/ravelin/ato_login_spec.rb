require 'spec_helper'

describe Ravelin::AtoLogin do
  let(:login_hash) do
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
  end

  subject do
    described_class.new(
      {
        "login": login_hash,
      }
    )
  end

  context 'creates instance with valid params' do
    it { expect { subject }.to_not raise_exception }
  end

  context 'creates a login object' do
    it { expect(subject.login.success).to eq(true) }
  end
end
