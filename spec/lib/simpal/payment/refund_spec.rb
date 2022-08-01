# frozen_string_literal: true

RSpec.describe Simpal::Payment::Refund do
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

    it { is_expected.to be_a(Simpal::PayPalObject) }

    it 'is expected to eq the refund' do
      expect(retrieve).to have_attributes(id: id)
    end
  end
end
