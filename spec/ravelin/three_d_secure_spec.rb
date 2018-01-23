require 'spec_helper'

describe Ravelin::ThreeDSecure do
  let(:timestamp) { Time.new(2017).to_i }
  let(:params) do
    {
      attempted:  true,
      success:    true,
      start_time: Time.new(2017),
      end_time:   Time.new(2017)
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

    context 'when 3DS has not finished yet' do
      let(:params) do
        {
          attempted:  true,
          success:    false,
          start_time: timestamp,
          end_time:   nil,
          timed_out:  false
        }
      end

      it 'does not include the end time' do
        expect(subject.serializable_hash).to eql(
          'attempted' => true,
          'success'   => false,
          'startTime' => timestamp,
          'timedOut'  => false
        )
      end
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
          'timedOut'  => true
        )
      end
    end
  end

  context 'when invalid timestamps are sent' do
    let(:less_than_one_hundred) { 99 }

    let(:params) do
      {
        attempted:  true,
        success:    true,
        start_time: less_than_one_hundred,
        end_time:   less_than_one_hundred,
        timed_out:  false
      }
    end

    it 'does not include the timestamps' do
      expect(subject.serializable_hash).to eql(
        'attempted' => true,
        'success'   => true,
        'timedOut'  => false
      )
    end
  end

  context 'when no timestamps are sent' do
    let(:params) do
      {
        attempted:  false,
        success:    false,
        start_time: nil,
        end_time:   nil,
        timed_out:  false
      }
    end

    it 'does not include the timestamps' do
      expect(subject.serializable_hash).to eql(
        'attempted' => false,
        'success'   => false,
        'timedOut'  => false
      )
    end
  end
end
