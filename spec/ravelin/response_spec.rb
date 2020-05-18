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
            'tagNames'             => ['credit_abuse'],
            'label'                => 'GENUINE',
            'tags'                 => '1234abc',
            'clientReviewedStatus' => -1
        })
      end

      it 'sets the attributes from the response' do
        expect(response.tag_names).to eq(['credit_abuse'])
        expect(response.label).to eq('GENUINE')
        expect(response.tags).to eq('1234abc')
        expect(response.client_reviewed_status).to eq(-1)
      end
    end

    context 'when Ravelin returns warnings' do
      let(:faraday_response) do
        double('faraday', status: 200, body: {
          'data' => {
            'warnings'    => [
              {
                "class" => "customer-absent-email",
                "help" => "https://developer.ravelin.com/apis/warnings/#customer-absent-email",
                "msg" => "Customer \"eg-cust-a1\" does not have an email address."
              },
              {
                "class" => "customer-absent-reg-time",
                "help" => "https://developer.ravelin.com/apis/warnings/#customer-absent-reg-time",
                "msg" => "Customer \"eg-cust-a1\" does not have a registration time."
              },
              {
                "class" => "order-absent-price",
                "help" => "https://developer.ravelin.com/apis/warnings/#order-absent-price",
                "msg" => "Order \"25857597\" does not have a price."
              }
            ]
          }
        })
      end

      it('returns the correct number of warnings') do
        expect(response.warnings.count).to eq(3)
      end
    end
  end
end
