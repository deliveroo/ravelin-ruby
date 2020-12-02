require 'spec_helper'

describe Ravelin::Order do
  describe '#items=' do
    let(:order) { described_class.new(order_id: 1, items: items, status: { stage: 'cancelled', reason: 'buyer' }) }

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

  describe '#app=' do
    let(:order) { described_class.new(order_id: 1, app: { name: "my cool app", platform: "web"}) }

    it 'has an app set' do
      expect(order.app.name).to eql("my cool app")
      expect(order.app.domain).to be_nil
      expect(order.app.platform).to eql("web")
    end

    context 'with an invalid platform' do
      let(:order) { described_class.new(order_id: 1, app: { name: "my cool app", platform: "shoes"}) }

      it 'fails validation' do
        expect { order }.to raise_error(ArgumentError)
      end

    end

    context 'with a valid domain' do
      let(:order) { described_class.new(order_id: 1, app: { name: "my cool app", domain: "a1.b.com"}) }
      it 'is valid' do
        expect { order }.not_to raise_error
      end
    end

    context 'with an invalid domain' do
      let(:order) { described_class.new(order_id: 1, app: { name: "my cool app", domain: "http://a1.b.com"}) }
      it 'fails validation' do
        expect { order }.to raise_error(ArgumentError)
      end
    end
  end
end
