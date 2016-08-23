require 'spec_helper'

describe Ravelin::Voucher do
  it 'creates instance with valid params' do
    expect { described_class.new(
      {
        :voucher_code => 'TEST123',
        :referrer_id => 1,
        :expiry => Time.now + 1,
        :value => 10,
        :currency => 'GBP',
        :voucher_type => 'REFERRAL',
        :referral_value => 10,
        :creation_time => Time.now
      }
    ) }.to_not raise_exception
  end

  it 'raises exception when missing required params' do
    expect { described_class.new({}) }.to raise_exception(
      ArgumentError,
      'missing parameters: voucher_code, referrer_id, expiry, value, currency, voucher_type, referral_value, creation_time'
    )
  end
end
