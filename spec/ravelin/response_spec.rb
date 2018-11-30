require 'spec_helper'

describe Ravelin::Response do
  describe '#initialize' do
    let(:response) { described_class.new(faraday_response) }
    context 'when an event is sent' do
      let(:faraday_response) do
        double('faraday', status: 200, body: {
            'data' => {
                'customerId'  => 'cus-123',
                'action'      => 'SUPPRESS',
                'score'       => 2,
                'scoreId'     => 'scr-123',
                'source'      => 'detective-fraud',
                'comment'     => 'Looks pretty sketchy'
            }
        })
      end

      it 'sets the attributes from the response' do
        expect(response.customer_id).to eq('cus-123')
        expect(response.action).to eq('SUPPRESS')
        expect(response.score).to eq(2)
        expect(response.score_id).to eq('scr-123')
        expect(response.source).to eq('detective-fraud')
        expect(response.comment).to eq('Looks pretty sketchy')
      end
    end

    context 'when a tag is sent' do
      let(:faraday_response) do
        double('faraday', status: 200, body: {
            'data' => {
                'customerId'  => 'cus-123',
                'tagNames'    => ['credit_abuse'],
                'label'       => 'GENUINE'
            }
        })
      end

      it 'sets the attributes from the response' do
        expect(response.tag_names).to eq(['credit_abuse'])
        expect(response.label).to eq('GENUINE')
      end
    end
  end
end
