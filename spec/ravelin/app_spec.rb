require 'spec_helper'

describe Ravelin::App do

  RSpec.shared_examples 'validates a valid domain' do |domain|
    subject { Ravelin::App.valid_domain?(domain)}

    it 'should be true' do
      expect(subject).to be_truthy
    end
  end

  RSpec.shared_examples 'rejects an invalid domain' do |domain|
    subject { Ravelin::App.valid_domain?(domain)}

    it 'should be false' do
      expect(subject).to be_falsey
    end
  end

  it_behaves_like 'validates a valid domain', 'www.blah.com'
  it_behaves_like 'validates a valid domain', 'www.my-cool-domain.com'

  it_behaves_like 'rejects an invalid domain', 'http://bobs.domain.com'
  it_behaves_like 'rejects an invalid domain', 'my_domain.com'


end
