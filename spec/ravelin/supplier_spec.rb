require 'spec_helper'

describe Ravelin::Supplier do
  subject do
    described_class.new(
      {
        type: "restaurant",
        supplier_id: 123,
      }
    )
  end

  context 'creates instance with valid params' do
    it { expect { subject }.to_not raise_exception }
  end

  it 'raises exception when missing required params' do
    expect { described_class.new({}) }.to raise_exception(ArgumentError, 'missing parameters: supplier_id, type')
  end
end
