require 'spec_helper'

describe Ravelin::Label do
  subject do
    described_class.new(
      customer_id: 1,
      label: label,
      comment: 'Did something bad',
      reviewer: {
        name: 'Foo Bar',
        email: 'foo@bar.com',
      }
    )
  end

  context 'creates instance with valid params' do
    let(:label) { 'FRAUDSTER' }

    it { expect { subject }.to_not raise_exception }
  end

  context 'fails if the label is wrong' do
    let(:label) { 'FOOBAR' }

    it { expect { subject }.to raise_error(Ravelin::InvalidLabelValueError) }
  end
end
