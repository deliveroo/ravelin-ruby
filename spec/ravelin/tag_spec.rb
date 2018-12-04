require 'spec_helper'

describe Ravelin::Tag do
  let(:tag) { described_class.new(payload: {}) }

  describe '#serializable_hash' do
    let(:payload) { { "customer_id": 1234, "tag_names": %w(tester staff) } }

    before { allow(tag).to receive(:payload).and_return(payload) }

    it 'returns a hash with the expected contents' do
      expect(tag.serializable_hash).to eq({
        "customerId" => 1234,
        "tagNames" => ["tester", "staff"]
      })
    end
  end
end
