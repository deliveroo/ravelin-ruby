require 'spec_helper'

describe Ravelin::AuthenticationMechanism do
  context 'for password authentication mechanisms' do
    subject do
      described_class.new(
        {
          password: {
            password: "lol",
            success: true
          }
        }
      )
    end

    context 'creates instance with valid params' do
      it { expect { subject }.to_not raise_exception }
    end

    context 'creates a password object' do
      it { expect(subject.password.success).to eq(true) }
    end
  end

  context 'for social authentication mechanisms' do
    subject do
      described_class.new(
        social: {
          success: false,
          social_provider: 'GOOGLE',
          failure_reason: 'SOCIAL_FAILURE'
        }
      )
    end

    it 'creates instance with valid params' do
      expect { subject }.to_not raise_exception
    end

    it 'creates a social object' do
      expect(subject.social.success).to eq(false)
    end
  end
end
