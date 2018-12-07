require 'spec_helper'

describe Ravelin::Client do
  describe '#initialize' do
    it 'initializes a Faraday connection' do
      expect(Faraday).to receive(:new).
        with('https://api.ravelin.com', kind_of(Hash))

      described_class.new(api_key: 'abc')
    end
  end

  let(:client) { described_class.new(api_key: 'abc') }

  shared_context 'event setup and stubbing' do
    let(:event_name) { 'foobar' }
    let(:event_payload) { { id: 'ch-123' } }
    let(:event) do
      double('event', name: event_name, serializable_hash: event_payload)
    end

    before { allow(client).to receive(:post) }
  end

  shared_context 'tag setup and stubbing' do
    let(:tag_name) { :tagname }
    let(:tag_payload) { { "customerId" => '123', "tagNames" => ['foo', 'bar'] } }
    let(:tag) do
      double('tag', name: tag_name, serializable_hash: tag_payload)
    end

    before { allow(client).to receive(:post) }
    before { allow(client).to receive(:delete) }
  end

  describe '#send_event' do
    include_context 'event setup and stubbing'

    it 'creates an event with method arguments' do
      expect(Ravelin::Event).to receive(:new).
        with(name: 'foo', timestamp: 12345, payload: { key: 'value' }).
        and_return(event)

      client.send_event(
        name: 'foo',
        timestamp: 12345,
        payload: { key: 'value' },
      )
    end

    it 'calls #post with Event payload' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/v2/foobar", { id: 'ch-123' })

      client.send_event
    end

    it 'calls #post with Event payload and score: true' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/v2/foobar?score=true", { id: 'ch-123' })

      client.send_event(score: true)
    end

    it 'calls #post with Event payload and score: false' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/v2/foobar", { id: 'ch-123' })

      client.send_event(score: false)
    end
  end

  describe '#send_backfill_event' do
    include_context 'event setup and stubbing'

    it 'creates an event with method arguments' do
      expect(Ravelin::Event).to receive(:new).
        with(name: 'foo', timestamp: 12345, payload: { key: 'value' }).
        and_return(event)

      client.send_backfill_event(
        name: 'foo',
        timestamp: 12345,
        payload: { key: 'value' }
      )
    end

    it 'calls #post /v2/backfill/{{event}} with Event payload' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/v2/backfill/foobar", { id: 'ch-123' })

      client.send_backfill_event(timestamp: Time.now)
    end

    it 'raises exception when timestamp argument is missing' do
      expect {
        client.send_backfill_event(name: :foobar, payload: {})
      }.to raise_exception(ArgumentError, /missing parameters: timestamp/)
    end
  end

  describe '#send_tag' do
    include_context 'tag setup and stubbing'

    it 'creates a tag with method arguments' do
      expect(Ravelin::Tag).to receive(:new).
          with(payload: {:tagNames=>['foo', 'bar']}).
          and_return(tag)

      client.send_tag(
          payload: { tagNames: ['foo', 'bar'] }
      )
    end

    it 'calls #post with Tag payload' do
      allow(Ravelin::Tag).to receive(:new) { tag }

      expect(client).to receive(:post).with('/v2/tag/customer',
          {
              "customerId" => '123',
              "tagNames" => ['foo', 'bar']
          }
      )

      client.send_tag
    end
  end

  describe '#delete_tag' do
    include_context 'tag setup and stubbing'

    context 'when deleting one tag' do
      let(:tag_payload) { { "customerId" => '123', "tagNames" => ['foo'] } }

      it 'calls #delete with Tag payload' do
        allow(Ravelin::Tag).to receive(:new) { tag }
        expect(client).to receive(:delete).with('/v2/tag/customer?customerId=123&tagName=foo')
        client.delete_tag
      end
    end

    context 'when deleting multiple tags' do
      it 'calls #delete with Tag payload' do
        allow(Ravelin::Tag).to receive(:new) { tag }
        expect(client).to receive(:delete).with('/v2/tag/customer?customerId=123&tagName=foo,bar')
        client.delete_tag
      end
    end
  end

  describe '#get_tag' do
    include_context 'tag setup and stubbing'

    context 'when deleting one tag' do
      let(:tag_payload) { { "customerId" => '123' } }

      it 'calls #get with customer id' do
        allow(Ravelin::Tag).to receive(:new) { tag }
        expect(client).to receive(:get).with('/v2/tag/customer?customerId=123')
        client.get_tag
      end
    end
  end

  describe '#post' do
    let(:client) { described_class.new(api_key: 'abc') }
    let(:event) do
      double('event', name: 'ping', serializable_hash: { name: 'value' })
    end

    before do
      allow(Ravelin::Event).to receive(:new).and_return(event)
    end

    it 'calls Ravelin with correct headers and body' do
      stub = stub_request(:post, 'https://api.ravelin.com/v2/ping').
        with(
          headers: { 'Authorization' => 'token abc' },
          body: { name: 'value' }.to_json,
        ).and_return(
          headers: { 'Content-Type' => 'application/json' },
          body: '{}'
        )

      client.send_event

      expect(stub).to have_been_requested
    end

    context 'response' do
      before do
        stub_request(:post, 'https://api.ravelin.com/v2/ping').
          to_return(
            status: response_status,
            body: body
          )
      end

      context 'successful' do
        shared_examples 'successful request' do
          it 'returns the response' do
            expect(client.send_event).to be_a(Ravelin::Response)
          end

          it "not treated as an error" do
            expect(client).to_not receive(:handle_error_response)

            client.send_event
          end
        end

        context 'when the response code is 200' do
          let(:response_status) { 200 }
          let(:body) { '{}' }
          it_behaves_like 'successful request'
        end

        context 'when the response code is 200' do
          let(:response_status) { 204 }
          let(:body) { '' }
          it_behaves_like 'successful request'
        end
      end

      context 'error' do
        let(:response_status) { 400 }
        let(:body) { '{}' }
        it 'handles error response' do
          expect(client).to receive(:handle_error_response).
            with(kind_of(Faraday::Response))

          client.send_event
        end
      end
    end
  end

  describe '#get' do
    let(:client) { described_class.new(api_key: 'abc') }
    let(:tag) do
      double('tag', name: 'ping', serializable_hash: { name: 'value' })
    end

    before do
      allow(Ravelin::Tag).to receive(:new).and_return(tag)
    end

    it 'calls Ravelin with correct headers and body' do
      stub = stub_request(:get, 'https://api.ravelin.com/v2/ping').
          with(
              headers: { 'Authorization' => 'token abc' },
              body: { name: 'value' }.to_json,
              ).and_return(
          headers: { 'Content-Type' => 'application/json' },
          body: '{}'
      )

      client.get_tag

      expect(stub).to have_been_requested
    end

    context 'response' do
      before do
        stub_request(:get, 'https://api.ravelin.com/v2/ping').
            to_return(
                status: response_status,
                body: body
            )
      end

      context 'successful' do
        shared_examples 'successful request' do
          it 'returns the response' do
            expect(client.get_tag).to be_a(Ravelin::Response)
          end

          it "not treated as an error" do
            expect(client).to_not receive(:handle_error_response)

            client.get_tag
          end
        end

        context 'when the response code is 200' do
          let(:response_status) { 200 }
          let(:body) { '{}' }
          it_behaves_like 'successful request'
        end

        context 'when the response code is 200' do
          let(:response_status) { 204 }
          let(:body) { '' }
          it_behaves_like 'successful request'
        end
      end

      context 'error' do
        let(:response_status) { 400 }
        let(:body) { '{}' }
        it 'handles error response' do
          expect(client).to receive(:handle_error_response).
              with(kind_of(Faraday::Response))

          client.get_tag
        end
      end
    end
  end

  describe '#handle null responses' do
    let(:event) { double('event', name: :ping, serializable_hash: {}) }
    let(:client) { described_class.new(api_key: 'abc') }

    before do
      allow(Ravelin::Event).to receive(:new).and_return(event)
      stub_request(:post, 'https://api.ravelin.com/v2/ping').
        and_return(status: status_code, body: "null")
    end

    context 'HTTP status 200' do
      let(:status_code) { 200 }

      it "successful" do
        expect(client.send_event).to be_a(Ravelin::Response)
      end
    end
  end

  describe '#handle_error_response' do
    shared_examples 'raises error with' do |error_class|
      it "raises #{error_class} error" do
        expect { client.send_event }.to raise_exception(error_class)
      end
    end

    let(:event) { double('event', name: :ping, serializable_hash: {}) }
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
