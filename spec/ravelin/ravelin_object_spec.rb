require 'spec_helper'

describe Ravelin::RavelinObject do
  before do
    described_class.attr_accessor :email, :full_name
    described_class.required_attributes :email
  end

  describe '#required_attributes' do
    it 'sets the #ravelin_required_attributes on the class' do
      expect(described_class.ravelin_required_attributes).to eq([:email])
    end
  end

  describe '#initialize' do
    it 'sets attributes from #new arguments' do
      obj = described_class.new(email: 'dummy@example.com')

      expect(obj.email).to eq('dummy@example.com')
    end

    it 'raises InvalidParametersError for undefined attributes' do
      expect {
        described_class.new(email: 'd@example.com', nickname: 'dummy')
      }.to raise_exception(NoMethodError, /nickname/)
    end
  end

  describe '#validate' do
    it 'raises InvalidParametersError for missing attributes' do
      expect {
        described_class.new(full_name: 'dummy')
      }.to raise_exception(Ravelin::InvalidParametersError, /email/)
    end
  end

  describe '#to_hash' do
    it 'builds a hash object with camelcases the hash keys' do
      obj = described_class.new(full_name: 'Dummy', email: 'd@example.com')

      expect(obj.to_hash).to eq({
        'fullName' => 'Dummy',
        'email' => 'd@example.com'
      })
    end

    it 'ignores properties with nil values' do
      obj = described_class.new(email: 'dummy@example.com')

      expect(obj.to_hash).to eq({ 'email' => 'dummy@example.com' })
    end
  end
end
