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
