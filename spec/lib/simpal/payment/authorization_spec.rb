# frozen_string_literal: true

RSpec.describe Simpal::Payment::Authorization do
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

    it 'is expected to eq the authorization' do
      expect(retrieve.id).to eq(id)
    end
  end

  describe '#reauthorize' do
    subject(:reauthorize) { described_class.reauthorize(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it { is_expected.to be_a(Simpal::PayPalObject) }

    it 'is expected to eq the updated authorization' do
      expect(reauthorize.id).to eq(id)
    end
  end

  describe '#capture' do
    subject(:capture) { described_class.capture(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it { is_expected.to be_a(Simpal::PayPalObject) }

    it 'is expected to eq the created capture' do
      # The mocking library reuses the authorization's ID on the capture to make testing easier.
      expect(capture.id).to eq(id)
      expect(capture.status).to eq('COMPLETED')
    end
  end

  describe '#void' do
    subject(:void) { described_class.void(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it { is_expected.to eq(true) }
  end
end
