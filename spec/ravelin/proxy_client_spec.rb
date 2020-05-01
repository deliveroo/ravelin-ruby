require 'spec_helper'

describe Ravelin::ProxyClient do
  let(:base_url) { 'http://127.0.0.1:8020' }
  let(:url_prefix) { '/ravelinproxy' }
  let(:username) { 'foo' }
  let(:password) { 'bar' }
  let(:base64_enc_user_pass) { 'Zm9vOmJhcg==' }

  describe '#initialize' do
    it 'initializes a Faraday connection' do
      expect(Faraday).to receive(:new).
        with(base_url, kind_of(Hash))

      described_class.new(base_url: base_url, url_prefix: url_prefix, username: username, password: password)
    end
  end

  let(:client) { described_class.new(base_url: base_url, url_prefix: url_prefix, username: username, password: password) }

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
    before { allow(client).to receive(:get) }
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

      expect(client).to receive(:post).with("/ravelinproxy/v2/foobar", { id: 'ch-123' })

      client.send_event
    end

    it 'calls #post with Event payload and score: true' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/ravelinproxy/v2/foobar?score=true", { id: 'ch-123' })

      client.send_event(score: true)
    end

    it 'calls #post with Event payload and score: false' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/ravelinproxy/v2/foobar", { id: 'ch-123' })

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

    it 'calls #post /ravelinproxy/v2/backfill/{{event}} with Event payload' do
      allow(Ravelin::Event).to receive(:new) { event }

      expect(client).to receive(:post).with("/ravelinproxy/v2/backfill/foobar", { id: 'ch-123' })

      client.send_backfill_event(timestamp: Time.now)
    end

    it 'raises exception when timestamp argument is missing' do
      expect {
        client.send_backfill_event(name: :foobar, payload: {})
      }.to raise_exception(ArgumentError, /missing parameters: timestamp/)
    end
  end


  describe '#post' do
    let(:client) { described_class.new(base_url: base_url, url_prefix: url_prefix, username: username, password: password) }
    let(:event) do
      double('event', name: 'ping', serializable_hash: { name: 'value' })
    end

    let(:headers) do
      {
        'Authorization' =>"Basic #{base64_enc_user_pass}",
        'User-Agent'    => "Ravelin Proxy RubyGem/#{Ravelin::VERSION}".freeze
      }
    end

    before do
      allow(Ravelin::Event).to receive(:new).and_return(event)
    end

    it 'calls Ravelin Proxy with correct headers and body' do
      stub = stub_request(:post, "http://127.0.0.1:8020/ravelinproxy/v2/ping").
        with(
          body: { name: 'value' }.to_json,
          headers: headers
        ).and_return(
          headers: { 'Content-Type' => 'application/json' },
          body: '{}')
      client.send_event

      expect(stub).to have_been_requested
    end
  end
end
