require 'spec_helper'

describe Ravelin::ProxyClient do
  let(:base_url) { 'http://127.0.0.1:8020' }
  let(:url_prefix) { 'ravelinproxy' }
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
