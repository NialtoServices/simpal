# frozen_string_literal: true

RSpec.describe Simpal do
  subject { described_class }

  it { is_expected.to respond_to(:client) }

  describe '::VERSION' do
    subject(:version) { described_class::VERSION }

    it 'is expected to be semantic' do
      expect(version).to match(/[0-9]+\.[0-9]+\.[0-9]+/)
    end
  end

  describe '#client_for' do
    subject(:client) { described_class.client_for(preferred_client) }

    let(:preferred_client) { nil }

    context 'when a preferred client is available' do
      let(:preferred_client) do
        Simpal::Client.new(client_id: 'ID', client_secret: 'SECRET', sandbox: true)
      end

      it 'is expected to eq the preferred client' do
        expect(client).to eq(preferred_client)
      end
    end

    context 'when a default client is available' do
      let(:default_client) do
        Simpal::Client.new(client_id: 'ID', client_secret: 'SECRET', sandbox: true)
      end

      around do |example|
        described_class.client = default_client
        example.call
      ensure
        described_class.client = nil
      end

      it 'is expected to eq the default client' do
        expect(client).to eq(default_client)
      end
    end

    context 'when no default or preferred client is available' do
      it { expect { client }.to raise_exception(Simpal::ClientError) }
    end
  end
end
