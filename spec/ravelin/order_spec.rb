require 'spec_helper'

describe Ravelin::Order do
  describe '#items=' do
    let(:order) { described_class.new(order_id: 1, items: items) }

    context 'argument not an array' do
      let(:items) { 'a string' }

      it 'raises ArgumentError' do
        expect { order }.to raise_exception(ArgumentError)
      end
    end

    context 'argument is an array' do
      let(:items) { [ { sku: 1, quantity: 1 }, { sku: 2, quantity: 1 }] }

      it 'converts Array items into Ravelin::Items' do
        expect(order.items).to include(
          instance_of(Ravelin::Item),
          instance_of(Ravelin::Item)
        )
      end
    end
  end
end
