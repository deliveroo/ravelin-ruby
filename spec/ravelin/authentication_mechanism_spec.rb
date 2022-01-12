require 'spec_helper'

describe Ravelin::AuthenticationMechanism do
  context 'for password authentication mechanisms' do
    subject do
      described_class.new(
        {
          password: {
            password: "super-secret-password",
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

  context 'for sms code authentication mechanisms' do
    subject do
      described_class.new(
        sms_code: {
          success: false,
          phone_number: '+447123456789',
          failure_reason: 'INVALID_CODE'
        }
      )
    end

    it 'creates instance with valid params' do
      expect { subject }.to_not raise_exception
    end

    it 'creates a sms code object' do
      expect(subject.sms_code.success).to eq(false)
    end
  end

  context 'for magic_link authentication mechanisms' do
    subject do
      described_class.new(
        magic_link: {
          transport: 'email',
          success: false,
          email:'joe@example.com',
          phone_number: '+447123456789',
          failure_reason: 'INVALID_LINK'
        }
      )
    end

    it 'creates instance with valid params' do
      expect { subject }.to_not raise_exception
    end

    it 'creates a magic_link object' do
      expect(subject.magic_link.success).to eq(false)
    end
  end
end
