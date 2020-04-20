# frozen_string_literal: true

require 'spec_helper'
#WebMock.disable_net_connect!(allow: '127.0.0.1')

describe Ravelin::ProxyClient do
  describe 'foo' do
    let(:proxy_client) do
      described_class.new(api_base_url: 'http://127.0.0.1:8020', api_key: 'xxxxxx')
    end

    it 'calls Ravlelin via the proxy' do
      #response = proxy_client.send_event(
      #  name: 'foo',
      #  timestamp: 12345,
      #  payload: { key: 'value' },
      #  )
      response = proxy_client.send_event(
        name: :order,
        payload: {
          customer_id: 'cus_123',
          order: {
            order_id: 'ord_123'
          }
        }
      )

      expect(response).to be_a(Ravelin::Response)
    end
  end
end
