require 'spec_helper'

describe Ravelin::RavelinObject do
  before do
    described_class.attr_accessor :name, :email_address, :address, :street
    described_class.attr_required :name
  end

  describe '.required_attributes' do
    it 'sets the .required_attributes on the class' do
      expect(described_class.required_attributes).to eq([:name])
    end
  end

  describe '#initialize' do
    it 'sets attributes from #new arguments' do
      obj = described_class.new(name: 'Dummy')

      expect(obj.name).to eq('Dummy')
    end

    it 'raises NoMethodError for undefined attributes' do
      expect {
        described_class.new(name: 'Dummy', nickname: 'dum dum')
      }.to raise_exception(NoMethodError, /nickname/)
    end
  end

  describe '#validate' do
    it 'raises ArgumentError for missing attributes' do
      expect {
        described_class.new(email_address: 'dummy@example.com')
      }.to raise_exception(ArgumentError, 'missing parameters: name')
    end
  end

  describe '#serialize' do
    it 'builds a hash object with camelcases the hash keys' do
      obj = described_class.new(name: 'Dummy', email_address: 'd@example.com')

      expect(obj.serialize).to eq({
        'name' => 'Dummy',
        'emailAddress' => 'd@example.com'
      })
    end

    it 'serializes nested Ravelin objects' do
      obj = described_class.new(name: 'Dummy')
      allow(obj).to receive(:address).
        and_return(described_class.new(name: 'Home', street: '123 St.'))

      expect(obj.serialize).to eq({
        'name' => 'Dummy',
        'address' => {
          'name' => 'Home',
          'street' => '123 St.'
        }
      })
    end

    it 'ignores properties with nil values' do
      obj = described_class.new(name: 'Dummy')

      expect(obj.serialize).to eq({ 'name' => 'Dummy' })
    end
  end
end
