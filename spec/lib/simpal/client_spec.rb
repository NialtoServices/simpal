# frozen_string_literal: true

RSpec.describe Simpal::Client do
  subject(:client) { described_class.new(client_id: client_id, client_secret: client_secret) }

  let(:client_id) { SecureRandom.urlsafe_base64(60) }
  let(:client_secret) { SecureRandom.alphanumeric(80) }

  describe '#initialize' do
    it 'is expected to assign :client_id to #client_id' do
      expect(client.client_id).to eq(client_id)
    end

    it 'is expected to assign :client_secret to #client_secret' do
      expect(client.client_secret).to eq(client_secret)
    end

    context 'when :sandbox is not provided' do
      it 'is expected to default #sandbox to `false`' do
        expect(client.sandbox).to eq(false)
      end
    end

    context 'when :sandbox is provided' do
      subject(:client) { described_class.new(client_id: client_id, client_secret: client_secret, sandbox: true) }

      it 'is expected to assign :sandbox to #sandbox' do
        expect(client.sandbox).to eq(true)
      end
    end
  end

  describe '#service_url' do
    subject(:service_url) { client.service_url }

    context 'when #sandbox eq `true`' do
      let(:client) { described_class.new(client_id: client_id, client_secret: client_secret, sandbox: true) }

      it 'is expected to eq the sandbox URL' do
        expect(service_url).to eq('https://api-m.sandbox.paypal.com')
      end
    end

    context 'when #sandbox eq `false`' do
      let(:client) { described_class.new(client_id: client_id, client_secret: client_secret, sandbox: false) }

      it 'is expected to eq the live URL' do
        expect(service_url).to eq('https://api-m.paypal.com')
      end
    end
  end

  describe '#connection' do
    subject(:connection) { client.connection }

    it { is_expected.to be_a(Faraday::Connection) }
  end
end
