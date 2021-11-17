require 'spec_helper'

describe Ravelin::Supplier do
  let(:location) { { location_id: "456" } }
  subject do
    described_class.new(
      {
        type: "restaurant",
        supplier_id: 123,
        home_location: location
      }
    )
  end

  context 'creates instance with valid params' do
    it { expect { subject }.to_not raise_exception }
  end

  it 'raises exception when missing required params' do
    expect { described_class.new({}) }.to raise_exception(ArgumentError, 'missing parameters: supplier_id, type')
  end

  describe '#home_location=' do
    context 'argument is not a location' do
      let(:location) { 'is a string' }

      it 'raises ArgumentError' do
        expect { subject }.to raise_exception(NoMethodError)
      end
    end

    context 'argument is a location' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_exception
        expect(subject.home_location.location_id).to eq "456"
      end
    end
  end
end
