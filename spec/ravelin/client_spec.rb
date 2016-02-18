require 'spec_helper'

describe Ravelin::Client do
  describe '#initialize' do
    it 'initializes a Faraday connection' do
      expect(Faraday).to receive(:new).
        with('https://api.ravelin.com', kind_of(Hash))

      described_class.new(api_key: 'abc')
    end
  end

  describe '#send_event' do
    let(:event_name) { 'my-event' }
    let(:event_payload) { { key: 'value' } }
    let(:event) { double('event', name: event_name, to_hash: event_payload) }
    let(:client) { described_class.new(api_key: 'abc') }

    before { allow(client).to receive(:post) }

    it 'creates an event with method arguments' do
      expect(Ravelin::Event).to receive(:new).
        with(name: 'my-event', payload: { key: 'value' }).
        and_return(event)

      client.send_event('my-event', event_payload)
    end

    it 'calls #post with Event payload' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/v2/my-event", { key: 'value' })

      client.send_event(event_name, event_payload)
    end
  end

  describe '#post' do
    let(:client) { described_class.new(api_key: 'abc') }
    let(:event) { double('event', name: 'ping', to_hash: { name: 'value' }) }

    before { allow(Ravelin::Event).to receive(:new).and_return(event) }

    it 'calls Ravelin with correct headers and body' do
      stub = stub_request(:post, 'https://api.ravelin.com/v2/ping').
        with(
          headers: { 'Authorization' => 'token abc' },
          body: { name: 'value' }.to_json
        )

      client.send_event(:ping, {})

      expect(stub).to have_been_requested
    end

    context 'response' do
      before do
        stub_request(:post, 'https://api.ravelin.com/v2/ping').
          to_return(status: response_status)
      end

      context 'successful' do
        let(:response_status) { 200 }

        it 'returns the response' do
          expect( client.send_event(:ping, {}) ).to be_a(Faraday::Response)
        end

        it "not treated as an error" do
          expect(client).to_not receive(:handle_error_response)

          client.send_event(:ping, {})
        end
      end

      context 'error' do
        let(:response_status) { 400 }

        it 'handles error response' do
          expect(client).to receive(:handle_error_response).
            with(kind_of(Faraday::Response))

          client.send_event(:ping, {})
        end
      end
    end
  end

  describe '#handle_error_response' do
    shared_examples 'raises error with' do |error_class|
      it "raises #{error_class} error" do
        expect { client.send_event(:ping, {}) }.to raise_exception(error_class)
      end
    end

    let(:event) { double('event', name: :ping, to_hash: {}) }
    let(:client) { described_class.new(api_key: 'abc') }

    before do
      allow(Ravelin::Event).to receive(:new).and_return(event)
      stub_request(:post, 'https://api.ravelin.com/v2/ping').
        and_return(status: status_code, body: "{}")
    end

    context 'HTTP status 400' do
      let(:status_code) { 400 }
      include_examples 'raises error with', Ravelin::InvalidRequestError
    end

    context 'HTTP status 403' do
      let(:status_code) { 403 }
      include_examples 'raises error with', Ravelin::InvalidRequestError
    end

    context 'HTTP status 404' do
      let(:status_code) { 404 }
      include_examples 'raises error with', Ravelin::InvalidRequestError
    end

    context 'HTTP status 405' do
      let(:status_code) { 405 }
      include_examples 'raises error with', Ravelin::InvalidRequestError
    end

    context 'HTTP status 406' do
      let(:status_code) { 406 }
      include_examples 'raises error with', Ravelin::InvalidRequestError
    end

    context 'HTTP status 401' do
      let(:status_code) { 401 }
      include_examples 'raises error with', Ravelin::AuthenticationError
    end

    context 'HTTP status 429' do
      let(:status_code) { 429 }
      include_examples 'raises error with', Ravelin::RateLimitError
    end

    context 'HTTP status 500' do
      let(:status_code) { 500 }
      include_examples 'raises error with', Ravelin::ApiError
    end
  end
end
