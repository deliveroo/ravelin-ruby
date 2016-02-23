require 'spec_helper'

describe Ravelin::Customer do
  it 'creates instance with valid params' do
    expect { described_class.new(customer_id: 'abc') }.to_not raise_exception
  end

  it 'raises exception when missing required params' do
    expect { described_class.new }.to raise_exception(
      ArgumentError,
      'missing parameters: customer_id'
    )
  end
end
