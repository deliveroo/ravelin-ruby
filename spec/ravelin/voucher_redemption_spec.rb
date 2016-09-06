require 'spec_helper'

describe Ravelin::VoucherRedemption do
  it 'creates instance with valid params' do
    expect { described_class.new(
      {
        :payment_method_id => 'voucher:594125',
        :voucher_code => 'FOOBAR9835',
        referrer_id: '10',
        :expiry => Time.now,
        :value => 10,
        :currency => 'GBP',
        :voucher_type => 'REFERRAL',
        :redemption_time => Time.now,
        :success => true,
      }
    ) }.to_not raise_exception
  end

  it 'raises exception when missing required params' do
    expect { described_class.new({}) }.to raise_exception(
      ArgumentError,
      'missing parameters: payment_method_id, voucher_code, referrer_id, value, currency, voucher_type, redemption_time, success'
    )
  end
end


