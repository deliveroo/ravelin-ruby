require 'spec_helper'

describe Ravelin::ThreeDSecure do
  let(:timestamp) { Time.new(2017).to_i }
  let(:params) do
    {
      attempted:  true,
      success:    true,
      start_time: timestamp,
      end_time:   timestamp
    }
  end

  subject do
    described_class.new(params)
  end

  describe '#serializable_hash' do
    it 'is camelized and well formed' do
      expect(subject.serializable_hash).to eql(
        'attempted' => true,
        'success'   => true,
        'startTime' => timestamp,
        'endTime'   => timestamp,
        'timedOut'  => false
      )
    end

    context 'when 3DS has timed out' do
      let(:params) do
        {
          attempted:  true,
          success:    false,
          start_time: timestamp,
          end_time:   nil,
          timed_out:  true
        }
      end

      it 'is still camelized and well formed' do
        expect(subject.serializable_hash).to eql(
          'attempted' => true,
          'success'   => false,
          'startTime' => timestamp,
          'endTime'   => 0,
          'timedOut'  => true
        )
      end
    end
  end
end
