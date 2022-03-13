# frozen_string_literal: true

RSpec.describe Simpal::API::Payments::Refunds do
  let(:client) { Simpal::Client.new(client_id: 'TEST_ID', client_secret: 'TEST_SECRET') }

  shared_examples 'bad credentials raise an exception' do
    context 'when using bad credentials' do
      let(:client) { Simpal::Client.new(client_id: 'BAD_ID', client_secret: 'BAD_SECRET') }

      it { expect { subject }.to raise_exception(Faraday::UnauthorizedError) }
    end
  end

  describe '#retrieve' do
    subject(:retrieve) { described_class.retrieve(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it 'is expected to eq the refund' do
      expect(retrieve).to match(hash_including('id' => id))
    end
  end
end
